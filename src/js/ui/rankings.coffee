import El from 'el.js'

export default class Rankings extends El.View
  tag: 'rankings'
  html: '<yield></yield>'
    
  init: ->
    super
    
    @data.on 'set', (k, v)=>
      if k == 'rankings'
        @scheduleUpdate()
    
Rankings.register()