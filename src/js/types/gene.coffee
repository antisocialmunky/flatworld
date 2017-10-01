import BodyBlock   from './bodyblock'
import MuscleBlock from './muscleblock'
import ThinkBlock  from './thinkblock'
import GoBlock     from './goblock'

export default class Gene
  a: 0
  b: 0
  sequence: null
    
  # take a, the block type, b block parameter
  constructor: (@a = 0, @b = 0, @sequence = []) ->
    
  # position blocks relative to primeBlock, convert gene to corresponding block
  _toBodyBlock: (primeBlock)->
    return new BodyBlock @b, primeBlock
  
  # position blocks relative to primeBlock, convert gene to corresponding block
  _toThinkBlock: (primeBlock)->
    return new ThinkBlock @b, primeBlock
  
  # position blocks relative to primeBlock, convert gene to corresponding block
  _toGoBlock: (primeBlock)->
    return new GoBlock @b, primeBlock
    
  # connect two blocks
  _toMuscleBlock: (primeBlock, blocks)->
    return new MuscleBlock @b, primeBlock, blocks
    
  # read int[] to generate a Gene[]
  @toGenes: (genums = [])->
    genes = []
    gene = []
    
    i = 0
    while i < genums.length 
      if genums[i] < 18
        gene = [genums[i], 1, [genums[i]]]
        genes.push gene
      else if gene.length > 0
        if i % 2 == 0
          gene[1] *= (genums[i] - 17)
        else
          gene[1] /= (genums[i] - 17)
          
        gene[2].push genums[i]
      
      i++
          
    return genes.map (gene)->
      return new Gene gene[0], gene[1], gene[2]
  
  # position blocks relative to primeBlock, read Gene[] and generate a Block[]
  @toBlocks: (primeBlock, genes = [])->
    blocks = []
    muscles = []
    
    # vertexblocks
    for gene in genes
      if gene.a < 4
        blocks.push gene._toBodyBlock primeBlock
      else if gene.a < 8
        blocks.push gene._toThinkBlock primeBlock
      else if gene.a < 12
        blocks.push gene._toGoBlock primeBlock
          
    # ... good luck ...
    if blocks.length == 0
      return blocks
        
    # muscleblocks
    for gene in genes
      if gene.a > 11 && gene.a < 18
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