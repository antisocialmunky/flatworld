import Simulation    from './engines/simulation'
import Render        from './engines/render'
import GenumsFactory from './types/genumsfactory'
import Organism      from './types/organism'
import ref           from 'referential'

# el.js stuff
import El from 'el.js'
import './ui/enginecontrols'
import './ui/indicators'
import './ui/rankings'

# create data
data = ref {}

# convert query params to object
search = location.search.substring 1
if search
  qs = JSON.parse '{"' + decodeURI(search).replace(/"/g, '\\"').replace(/&/g, '","').replace(/=/g,'":"') + '"}'
else
  qs = {}
    
data.set 'seed', parseInt qs.seed, 10
  
genumsFactory = new GenumsFactory data
simulation    = new Simulation data, genumsFactory, false

if qs.resume == '1'
  simulation.restoreWorld()
  document.body.querySelector('#loader').classList.add 'hide'
  simulation.start()
  
else
  # make 1000 organisms
  i = 0
  createOrganism = ->
    genums   = genumsFactory.generate 10
    organism = new Organism genums

    simulation.addOrganism organism
    
    i++
    if i < 100
      createOrganism() 
    else
      document.body.querySelector('#loader').classList.add 'hide'
      simulation.start()
      
  setTimeout createOrganism, 500

El.mount '*',
  data: data