import El from 'el.js'

export default class EngineControls extends El.View
  tag: 'engine-controls'
  html: '<yield></yield>'
    
  init: ->
    super
      
    @data.on 'set', (k, v)=>
      if k == 'records'
        @scheduleUpdate()     
        
  isPaused: ->
    return !!(@data.get 'paused')
    
  togglePause: ->
    @data.set 'paused', !@isPaused()
    @update()
    
  slowDown: ->
    @data.set 'speed', Math.max(@data.get('speed') / 2, .125)
    
  speedUp: ->
    @data.set 'speed', @data.get('speed') * 2
    
EngineControls.register()