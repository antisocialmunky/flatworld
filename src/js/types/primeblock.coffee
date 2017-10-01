import Matter from 'matter-js'
import Block  from './block'

Bodies = Matter.Bodies
Body   = Matter.Body

TAU = Math.PI * 2

export default class PrimeBlock extends Block
  @x: 0
  @y: 0
  @angle: 0
  
  body: null
  
  type: 'prime-block'
  
  # read the 2 block params b and c as well as the origin and initial angle
  constructor: (
    @x = 0, 
    @y = 0, 
    @angle = (Math.random() * 1000) % TAU
  )-> 
    super
    
    @body = Matter.Bodies.circle @x, @y, 24, 
      angle: @angle
      
    @body._parentBlock = @
  
    @addHidden 0