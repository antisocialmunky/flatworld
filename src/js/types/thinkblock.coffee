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

export default class ThinkBlock extends Block
  b: 0
  c: 0
  
  distance: 0
  angle: 0
  x: 0
  y: 0
  bias: 0
  
  body: null
  primeBlock: null
  
  type: 'think-block'
  
  # read the 2 block params b and c as well as the origin and initial angle
  constructor: (@b = 0, @primeBlock)->
    super
    
    b = @b
    primeBlock = @primeBlock
       
    @distance = b % distanceRange + minDistance
    
    @angle = (b + primeBlock.body.angle) % TAU
    offsetX = @distance * cos @angle
    offsetY = @distance * sin @angle
    @x = offsetX + primeBlock.body.position.x
    @y = offsetY + primeBlock.body.position.y
    
    @body = Matter.Bodies.circle @x, @y, 12, 
      angle: @angle
    
    @body._parentBlock = @
    
    @addHidden b - (b % Math.floor(Math.pow(10, Math.floor(Math.log10(b))))) * 10