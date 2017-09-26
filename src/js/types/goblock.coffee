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

export default class GoBlock
  b: 0
  c: 0
  
  distance: 0
  angle: 0
  x: 0
  y: 0

  inputBias: 0
  outputBias: 0
  force: 0
  maxForce: 0
  
  collisions: 0
  body: null
  
  type: 'go-block'
  
  # read the 2 block params b and c as well as the origin and initial angle
  constructor: (b = 0, c = 0, x = window.innerWidth / 2, y = window.innerHeight / 2, initialAngle = 0)->
    @b = b
    @c = c 
    @inputBias = b % 10 - 5
    @outputBias = c % 10 - 5
    
    @size = 20
    
    @distance = c % distanceRange + minDistance
    
    @angle = (b + initialAngle) % TAU
    offsetX = @distance * cos @angle
    offsetY = @distance * sin @angle
    @x = offsetX + x
    @y = offsetY + y
    
    @maxForce = b % 0.001
    
    @body = Matter.Bodies.rectangle @x, @y, @size, @size, { angle: @angle }
    
    @body._parentBlock = @
       
  perceptronInput: ()->
    return @force / @maxForce
        
  neuronInputBias: ()->
    return @bias
    
  perceptronOutput: (percent)->
    @force = Math.round(percent) * @maxForce
    radius = @size / 2
    Matter.Body.applyForce @body, {x: -cos(@body.angle) * radius, y: -sin(@body.angle) * radius }, { x: cos(@body.angle) * @force, y: sin(@body.angle) * @force }
    
  neuronOutputBias: ()->
    return @bias