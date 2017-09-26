import Matter from 'matter-js'

import {
  minDistance
  distanceRange 
  minSize
} from './constants'

Constraint = Matter.Constraint

export default class MuscleBlock
  b: 0
  c: 0
  stiffness: 0
  distance:  0
  
  blockA: null
  blockB: null
  body:   null
  
  # entension lengths
  length1: 0
  length2: 0
  length:  0
  
  lengthRange: 0
  
  inputBias:  0
  outputBias: 0
  
  type: 'muscle-block'

  # read the 2 block params b and c as well as vertex blocks (including prime)
  constructor: (b, c, primeBlock, blocks, constraints)->
    if blocks.length == 0
      return
  
    @stiffness = b % 1
    @inputBias = c % 10 - 5
    @outputBias = b / c % 10 - 5
    
    numBlocks = blocks.length + 1
    i1 = Math.round(b) % numBlocks
    i2 = Math.round(c) % numBlocks
    
    if i1 == i2
      i2 = (i2 + 1) %numBlocks
      
    @blockA = blocks[i1 - 1] ? primeBlock
    @blockB = blocks[i2 - 1] ? primeBlock
    
    # annotate muscle connections
    @connectMuscle @blockA
    @connectMuscle @blockB
    
    @length = (b * c * 3) % distanceRange + minDistance
      
    # length 1 is the shorter one
    @length1 = @length * .5
    @length2 = @length * 1.5
    @lengthRange = @length2 - @length1
    
    @body = Constraint.create 
      bodyA: @blockA.body
      pointA: 
        x: b * 5 % minSize * 2 - minSize
        y: c * 5 % minSize * 2 - minSize 
      bodyB: @blockB.body
      pointB: 
        x: b * 7 % minSize * 2 - minSize
        y: c * 7 % minSize * 2 - minSize
      stiffness: .9 # @stiffness
      damping: 0.01
      length: @length
      render:
        lineWidth: 1
        
    @body._parentBlock = @
    
  # annotate muscles to a block
  connectMuscle: (block)->
    if !block._muscles?
      block._muscles = [@]
    else
      block._muscles.push @
  
  # send the length
  perceptronInput: ()->
    return (@length - @length1) / @lengthRange 
    
  # modify the length
  perceptronOutput: (percent)->
    @length = @body.length = @lengthRange * percent  + @length1
  
  neuronInputBias: ()->
    return @inputBias
    
  neuronOutputBias: ()->
    return @outputBias