import Matter   from 'matter-js'
import Stats    from 'stats.js'
import Organism from '../types/organism'

Body   = Matter.Body
Bodies = Matter.Bodies
Bounds = Matter.Bounds
Engine = Matter.Engine
Events = Matter.Events
Mouse  = Matter.Mouse
Render = Matter.Render
World  = Matter.World

PERIOD = 1000/60

export default class Simulation 
  width:  0
  height: 0
  data:   null
  engine: null
  render: null
  
  genumsFactory:  null
  organisms:      null
  activeOrganism: null
  
  rankings: null
  
  autoStart: false
  started: false
  
  # @data speed
  # @data paused
  # @data rankings
  # @data generation
   
  constructor: (@data, @genumsFactory, @autoStart = false)->
    # window size:
    @width  = width  = window.innerWidth - 10
    @height = height = window.innerHeight - 10

    # create an engine and pause it
    @engine = engine = Engine.create()
    engine.world.gravity.y = 0
    
    stats = new Stats()
    stats.showPanel 0
    document.body.appendChild stats.dom
    
    halfWidth  = width / 2
    halfHeight = height / 2
    
    # create a renderer
    @render = render = Render.create
      element: document.body.querySelector '#viewport'
      engine: engine
      options:
        width:  width
        height: height
        showAngleIndicator: true
        hasBounds: true
        
    # create two boxes and a ground
    # boxA = Bodies.rectangle 400, 200, 80, 80
    # boxB = Bodies.rectangle 450, 50, 80, 80
    
    # Body.applyForce boxA, { x: 0, y: 0 }, {x: Math.random() * .5 - .25, y: Math.random() * .5, - .25}
    
    # add all of the bodies to the world
    # World.add engine.world, [boxA, boxB]
    
    # World.add engine.world, Bodies.rectangle(width/2, 0, width, 40, { isStatic: true })
    # World.add engine.world, Bodies.rectangle(width/2, height, width, 40, { isStatic: true })
    # World.add engine.world, Bodies.rectangle(width, height/2, 40, height, { isStatic: true })
    # World.add engine.world, Bodies.rectangle(0, height/2, 40, height, { isStatic: true })
    
    for i in [0...20]
      World.add engine.world, Bodies.circle 0, 0, i * 100, 
        isStatic: true        
        isSensor: true
        
    Bounds.translate render.bounds, 
      x: -halfWidth
      y: -halfHeight
            
    # organisms
    @rankings = []
    @organisms = []
      
    # set up @data
    @data.set 'speed', 1
    @data.set 'paused', false
    @data.set 'rankings', @rankings
    @data.set 'generation', 1
    
    @lastExecution = new Date()
    
    Events.on @engine, 'beforeUpdate', =>
      stats.begin()
      
    Events.on @engine, 'afterUpdate', =>
      stats.end()
            
      if @activeOrganism
        Render.lookAt @render, @activeOrganism.primeBlock.body, 
          x: 300
          y: 300
        
      @scheduleThinkTime()
      
    Events.on @engine, 'collisionActive', (e)=>
      for pair in e.pairs
        pair.bodyA._parentBlock?.oncollisionActive?()
        pair.bodyB._parentBlock?.oncollisionActive?()
        
  # add an organism to the simulation
  addOrganism: (organism)->
    @organisms.push organism
    
    if @autoStart && @organisms.length == 1
      @start()
        
  start: ()->
    if @organisms.length == 0
      console.log 'Error: No Organisms'
      return
  
    i = 0
    @activeOrganism = @organisms[i]
    @data.set 'activeOrganism', @activeOrganism
    
    @_testOrganism @activeOrganism   
        
    Events.on @engine, 'afterUpdate', (e)=>
      date = Math.floor e.timestamp
      @data.set 'stopwatchNow', date
      
      oldDate = @data.get 'stopwatchStart'
      if date - oldDate > 10000
      
        i++
        # while @organisms[i] && @organisms[i].getBodies().length == 1
        #  i++
        
        # record data
        x = @activeOrganism.primeBlock.body.position.x
        y = @activeOrganism.primeBlock.body.position.y
  
        distance = Math.sqrt(x * x + y * y) / 100
        
        ranking =
          organism: @activeOrganism
          img:      @render.canvas.toDataURL()
          distance: distance
        
        added = false
        for r, j in @rankings
          if r.distance <= ranking.distance
            @rankings.splice j, 0, ranking
            added = true
            break
          
        if !added
          @rankings.push ranking
          
        if @rankings.length > @organisms.length
          @rankings.length = @organisms.length
          
        @data.set 'rankings', @rankings
        
        @activeOrganism = @organisms[i]
        
        # test next organism
        if @activeOrganism
          @_testOrganism @activeOrganism, e
        # test another organism
        else
          i = 0
          @data.set 'generation', @data.get('generation') + 1
          count = Math.floor(@organisms.length / 2) - 1
          
          @organisms.length = 0
          for j in [0..count]
            g        = @genumsFactory.mutate @rankings[j].organism.genums
            organism = new Organism g
            @organisms.push organism

            g        = @genumsFactory.mutate @rankings[j].organism.genums
            organism = new Organism g
            @organisms.push organism
          
          @activeOrganism = @organisms[i]
        
        @data.set 'activeOrganism', @activeOrganism
        
    cyclesTodo = 0
    # run the render
    run = =>
      if !@data.get 'paused'
        cyclesTodo += @data.get 'speed'
        cyclesDone = 0
        if cyclesTodo >= 1
          for _ in [1..cyclesTodo]
            cyclesDone++
            Engine.update @engine, PERIOD
            # incase pausing is triggered in the engine
            if @data.get 'paused'
              return
              
        cyclesTodo -= cyclesDone
        
      requestAnimationFrame run
      
    run()
    
    # run the renderer
    Render.run @render
  
  resume: ()->  
    @data.set 'paused', false
  
  pause: ()->
    @data.set 'paused', true

  # test an organism
  _testOrganism: (organism, e) ->
    World.clear @engine.world, true
    bodies = organism.getBodies()
    World.add @engine.world, bodies
    @data.set 'stopwatchStart', Math.floor(e?.timestamp ? 0)
              
  # schedule organism thinking
  scheduleThinkTime: (time)->
    if !@activeOrganism
      return
      
    time = new Date()
    if time - @lastExecution > 1000
      @lastExecution = time
      @activeOrganism.think()