import Block       from './block'
import MuscleBlock from './muscleblock'
import ThinkBlock  from './thinkblock'
import GoBlock     from './goblock'

export default class Gene
  a: 0
  b: 0
  c: 0
    
  # take a, the block type, b, and c (the two block params)
  constructor: (@a = 0, @b = 0, @c = 0) ->
    
  # position blocks relative to primeBlock, convert gene to corresponding block
  _toBlock: (primeBlock)->
    primeBody = primeBlock.body
    return new Block @b, @c, primeBody.position.x, primeBody.position.y, primeBody.angle
  
  # position blocks relative to primeBlock, convert gene to corresponding block
  _toThinkBlock: (primeBlock)->
    primeBody = primeBlock.body
    return new ThinkBlock @b, @c, primeBody.position.x, primeBody.position.y, primeBody.angle
  
  # position blocks relative to primeBlock, convert gene to corresponding block
  _toGoBlock: (primeBlock)->
    primeBody = primeBlock.body
    return new GoBlock @b, @c, primeBody.position.x, primeBody.position.y, primeBody.angle
    
  # connect two blocks
  _toMuscleBlock: (primeBlock, blocks)->
    return new MuscleBlock @b, @c, primeBlock, blocks
    
  # read int[] to generate a Gene[]
  @toGenes: (genums = [])->
    genes = []
    gene = []
    
    count = 0
    for genum in genums 
      gene.push genum
      
      if gene.length == 3
        genes.push gene
        gene = []
          
    return genes.map (gene)->
      return new Gene gene[0], gene[1], gene[2]
  
  # position blocks relative to primeBlock, read Gene[] and generate a Block[]
  @toBlocks: (primeBlock, genes = [])->
    blocks = []
    muscles = []
    
    # vertexblocks
    for gene in genes
      choice = Math.round(gene.a) % 12
      switch choice
        when 0, 1
          blocks.push gene._toBlock primeBlock
        when 2, 3
          blocks.push gene._toThinkBlock primeBlock
        when 4, 5
          blocks.push gene._toGoBlock primeBlock
          
    # ... good luck ...
    if blocks.length == 0
      return blocks
        
    # muscleblocks
    for gene in genes
      choice = Math.round(gene.a) % 12
      switch choice
        when 6, 7, 8, 9, 10, 11
          muscles.push gene._toMuscleBlock primeBlock, blocks
          
    # 233940816 gives interesting results with this and 40 elements
    # vertexblocks
    # for gene in genes
      # choice = Math.round(gene.a) % 12
      # switch choice
        # when 0, 1
          # blocks.push gene._toBlock primeBlock
        # when 2, 3, 4
          # blocks.push gene._toThinkBlock primeBlock
        # when 12
          # blocks.push gene._toGoBlock primeBlock
          
    #... good luck ...
    # if blocks.length == 0
      # return blocks
        
    # muscleblocks
    # for gene in genes
      # choice = Math.round(gene.a) % 12
      # switch choice
        # when 5, 6, 7, 8, 9, 10, 11
          # muscles.push gene._toMuscleBlock primeBlock, blocks
          
    return blocks.concat muscles