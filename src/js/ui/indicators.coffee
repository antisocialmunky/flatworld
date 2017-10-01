import El     from 'el.js'
import moment from 'moment'

export default class Indicators extends El.View
  tag: 'indicators'
  html: '<yield></yield>'
    
  init: ->
    super
    
    # this should be clock triggered around 60fps
    @data.on 'set', (k) =>
      if k == 'stopwatchNow'
        @scheduleUpdate()
    
  renderTimer: ()->
    startTime = @data.get 'stopwatchStart'
    currentTime = @data.get 'stopwatchNow'
       
    if !startTime? || !currentTime?
      return 'N/A'
      
    return moment(Math.round(currentTime - startTime)).format 'mm:ss:SS'
  
  renderDistance: ()->
    organism = @data.get 'activeOrganism'
    
    if !organism
      return ''
         
    return organism.fitness().toFixed(2) + 'm'
            
Indicators.register()