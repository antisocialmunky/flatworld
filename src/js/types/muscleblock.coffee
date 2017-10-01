import Matter from 'matter-js'
import Block  from './block'

import {
  minDistance
  distanceRange 
  minSize
} from './constants'

Constraint = Matter.Constraint

export default class MuscleBlock extends Block
  b: 0
  stiffness: 0
  distance:  0
  
  blockA: null
  blockB: null
  body:   null
  primeBlock: null
  
  # entension lengths
  length1: 0
  length2: 0
  length:  0
  
  lengthRange: 0
  
  type: 'muscle-block'

  # read the 2 block params b and c as well as vertex blocks (including prime)
  constructor: (@b, @primeBlock, blocks)->
    super
    
    if blocks.length == 0
      return
  
    b = @b
    c = (b % Math.floor(Math.pow(10, Math.floor(Math.log10(b))))) * 10 || 0
    d = (c % Math.floor(Math.pow(10, Math.floor(Math.log10(c))))) * 10 || 0
  
    @stiffness = b % 1
        
    numBlocks = blocks.length + 1
    i1 = Math.round(b) % numBlocks
    i2 = Math.round(c) % numBlocks
    
    if i1 == i2
      i2 = (i2 + 1) %numBlocks
      
    @blockA = blocks[i1 - 1] ? @primeBlock
    @blockB = blocks[i2 - 1] ? @primeBlock
    
    # annotate muscle connections
    @connectMuscle @blockA
    @connectMuscle @blockB
    
    @length = b % distanceRange + minDistance
      
    # length 1 is the shorter one
    @length1 = @length * .5
    @length2 = @length * 1.5
    @lengthRange = @length2 - @length1
    
    @body = Constraint.create 
      bodyA: @blockA.body
      pointA: 
        x: b % minSize - minSize / 2
        y: (b - c) % minSize - minSize / 2
      bodyB: @blockB.body
      pointB: 
        x: c % minSize - minSize / 2
        y: (c - d) % minSize - minSize / 2
      stiffness: .9 # @stiffness
      damping: 0.01
      length: @length
      render:
        lineWidth: 1
        
    @body._parentBlock = @
    
    @addInput b - c, ()=>
      return (@length - @length1) / @lengthRange 
      
    @addOutput c - d, (percent)=>
      @length = @body.length = @lengthRange * percent  + @length1
    
  # annotate muscles to a block
  connectMuscle: (block)->
    if !block._muscles?
      block._muscles = [@]
    else
      block._muscles.push @