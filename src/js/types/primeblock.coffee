import Matter from 'matter-js'

Bodies = Matter.Bodies
Body   = Matter.Body

TAU = Math.PI * 2

export default class PrimeBlock
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
    @body = Matter.Bodies.circle @x, @y, 20, 
      angle: @angle
      
    @body._parentBlock = @
      
  # the prime block, gives an alternating clock wave for perceptron input
  neuronHiddenBias: ()->
    return 0