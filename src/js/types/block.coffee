import Matter from 'matter-js'
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

export default class Block
  b: 0
  c: 0
  
  distance: 0
  angle: 0
  x: 0
  y: 0
  size: 0
  bias: 0
  
  collisions: 0
  body: null
  
  type: 'block'
  
  # read the 2 block params b and c as well as the origin and initial angle
  constructor: (b = 0, c = 0, x = window.innerWidth / 2, y = window.innerHeight / 2, initialAngle = 0)->
    @b = b
    @c = c 
    @bias = c % 10 - 5
    
    @size = (b * c) % sizeRange + minSize
    
    @distance = c % distanceRange + minDistance
    
    @angle = (b + initialAngle) % TAU
    offsetX = @distance * cos @angle
    offsetY = @distance * sin @angle
    @x = offsetX + x
    @y = offsetY + y
    
    @body = Matter.Bodies.circle @x, @y, @size, { angle: @angle }
    
    @body._parentBlock = @
       
  perceptronInput: ()->
    ret = @collisions
    @collisions = 0
    return @collisions
    
  neuronInputBias: ()->
    return @bias
    
  # events
  oncollisionActive: ()->
    @collisions++