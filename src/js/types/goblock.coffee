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

export default class GoBlock extends Block
  b: 0
  
  distance: 0
  angle: 0
  x: 0
  y: 0

  force: 0
  maxForce: 0
  
  collisions: 0
  body: null
  primeBlock: null
  
  type: 'go-block'
  
  # read the 2 block params b and c as well as the origin and initial angle
  constructor: (@b, @primeBlock)->
    super
    
    primeBlock = @primeBlock
    
    b = @b
    c = (b % Math.floor(Math.pow(10, Math.floor(Math.log10(b))))) * 10 || 0
    d = (c % Math.floor(Math.pow(10, Math.floor(Math.log10(c))))) * 10 || 0
        
    @size = 20
    
    @distance = b % distanceRange + minDistance
    
    @angle = (b + primeBlock.body.angle) % TAU
    offsetX = @distance * cos @angle
    offsetY = @distance * sin @angle
    @x = offsetX + primeBlock.body.position.x
    @y = offsetY + primeBlock.body.position.y
    
    @maxForce = b % 0.0001
    
    @body = Matter.Bodies.rectangle @x, @y, @size, @size,
      angle: @angle
    
    @body._parentBlock = @
    
    @addInput b - c, ()=>
      return @force / @maxForce
      
    @addInput c - d, ()=>
      return (@body.angle - primeBlock.body.angle  + TAU) % TAU
      
    @addOutput b - d, (percent)=>
      @force = Math.round(percent) * @maxForce
      radius = @size / 2
      Matter.Body.applyForce @body, {x: -cos(@body.angle) * radius, y: -sin(@body.angle) * radius }, { x: cos(@body.angle) * @force, y: sin(@body.angle) * @force }