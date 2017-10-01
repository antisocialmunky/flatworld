import Matter from 'matter-js'
import Block  from './block'

import {
  minSize
  sizeRange
  minDistance
  distanceRange
} from './constants'

PI  = Math.PI
TAU = PI * 2
cos = Math.cos
sin = Math.sin

export default class BodyBlock extends Block
  b: 0
  
  distance: 0
  angle: 0
  x: 0
  y: 0
  size: 0
  
  collisions: 0
  body: null
  primeBlock: null
  
  type: 'body-block'
  
  # read the 2 block params b and c as well as the origin and initial angle
  constructor: (@b = 0, @primeBlock)->
    super
    
    b = @b
    c = (b % Math.floor(Math.pow(10, Math.floor(Math.log10(b))))) * 10 || 0
    d = (c % Math.floor(Math.pow(10, Math.floor(Math.log10(c))))) * 10 || 0
    
    primeBlock = @primeBlock
    
    @size = b % sizeRange + minSize
    
    @distance = b % distanceRange + minDistance
    
    @angle = (b + primeBlock.body.angle) % TAU
    offsetX = @distance * cos @angle
    offsetY = @distance * sin @angle
    @x = offsetX + primeBlock.body.position.x
    @y = offsetY + primeBlock.body.position.y
    
    @body = Matter.Bodies.circle @x, @y, @size,
      angle: @angle
    
    @body._parentBlock = @
    
    @addInput b - c, ()=>
      ret = @collisions
      @collisions = 0
      return @collisions
      
    @addInput c - d, ()=>
      return (@body.angle - @primeBlock.body.angle  + TAU) % TAU
        
  # events
  oncollisionActive: ()->
    @collisions++