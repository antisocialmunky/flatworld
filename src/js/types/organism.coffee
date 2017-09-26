import Matter   from 'matter-js'

Bodies     = Matter.Bodies
Body       = Matter.Body
Constraint = Matter.Constraint
Network    = synaptic.Network
Layer      = synaptic.Layer

import Gene       from './gene'
import PrimeBlock from './primeblock'

_id = 0

export default class Organism
  id: 0
  genums: null
  genes: null
  primeBlock: null
  blocks: null
  
  bodies:  null
  
  # neurons
  inputs:  null
  hiddens: null
  outputs: null
  
  perceptron: null
  
  # take a genums
  constructor: (@genums = [])->
    @id = _id++
  
    # initialize the PrimeBlock
    @primeBlock = new PrimeBlock()
    
    @genes  = Organism._compileGenes @genums
    @blocks = Organism._compileBlocks @primeBlock, @genes
    
    if @blocks.length == 0
      return
    
    @bodies = Organism._compileBodies @blocks
    
    # filter out the muscle types
    @nonConstraints = bodies = []
    for body in @bodies
      bodies.push body if body._parentBlock.type != 'muscle-block'
             
    [@inputs, @hiddens, @outputs] = Organism._compilePerceptronLayers @blocks
           
    @perceptron = Organism._compilePerceptron @inputs, @hiddens, @outputs
 
  # get a concatination of bodies and constraints, a short hand for adding to the world
  getBodies: ()->
    return @bodies ? [@primeBlock.body]
    
  # get a list of non-contraint bodies only
  getNonConstraints: ()->
    return @nonConstraints ? [@primeBlock.body]
  
  # execute one loop of the perceptron
  think: ()->
    if !@perceptron?
      return
    
    inputData = (input.perceptronInput() for input in @inputs)
    outputData = @perceptron.activate inputData
    for output, i in @outputs
      @outputs[i].perceptronOutput outputData[i]
             
  # create and populate genes from genum
  @_compileGenes: (genums)->
    # convert genums to genes
    return Gene.toGenes genums
    
  # create and populate blocks from genes
  @_compileBlocks: (primeBlock, genes)->
    # convert genes to blocks
    initialBlocks = Gene.toBlocks primeBlock, genes
     
    @_idBlocks initialBlocks
    
    i = 0
    
    connectedFilter = {}
    connectedBlocks = [primeBlock]
    while connectedBlocks[i]
      block = connectedBlocks[i]
      
      connectedFilter[block._id] = true
     
      # determine which blocks are connected to
      switch block.type
        when 'muscle-block'
          blockA = block.blockA
          blockB = block.blockB
          if !connectedFilter[blockA._id]
            connectedBlocks.push blockA
            connectedFilter[blockA._id] = true
          if !connectedFilter[blockB._id]
            connectedBlocks.push blockB
            connectedFilter[blockB._id] = true
        else
          if block._muscles
            for muscle in block._muscles
              if !connectedFilter[muscle._id]
                connectedBlocks.push muscle
                connectedFilter[muscle._id] = true
      i++
  
    @_idBlocks connectedBlocks
    
    return connectedBlocks
  
  # add id to blocks
  @_idBlocks: (blocks) ->
    for block, i in blocks
      block._id = i
    
  # create and populate bodies from blocks
  @_compileBodies: (blocks)->
    # store bodies
    return (block.body for block in blocks)
  
  @_compilePerceptronLayers: (blocks)->
    inputs  = []
    hiddens = []
    outputs = []
    
    for block in blocks
      if block.neuronInputBias?
        inputs.push block
        
      if block.neuronHiddenBias?
        hiddens.push block
        
      if block.neuronOutputBias?
        outputs.push block
    
    return [inputs, hiddens, outputs]
    
  @_compilePerceptron: (inputs, hiddens, outputs)->
    if inputs.length && hiddens.length && outputs.length 
      inputLayer = new Layer inputs.length
      
      for input, i in inputs
        inputLayer.list[i].bias = input.neuronInputBias()
      
      hiddenLayer = new Layer hiddens.length
      for h, i in hiddens
        hiddenLayer.list[i].bias = h.neuronHiddenBias()
        
      outputLayer = new Layer outputs.length
      for output, i in outputs
        outputLayer.list[i].bias = output.neuronOutputBias()

      inputLayer.project hiddenLayer
      hiddenLayer.project outputLayer
        
      return new Network
        input:  inputLayer
        hidden: [hiddenLayer]
        output: outputLayer
        
    return null