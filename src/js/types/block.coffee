import Neuron from './neuron'

# basal block for inheritence
export default class Block
  inputs:  null
  hiddens: null
  outputs: null
  
  constructor: ()->
    @inputs  = []
    @hiddens = []
    @outputs = []
    
  addInput: (bias, fn)->
    @inputs.push new Neuron(bias, fn)
    
  addHidden: (bias)->
    @hiddens.push new Neuron(bias)
    
  addOutput: (bias, fn)->
    @outputs.push new Neuron(bias, fn)