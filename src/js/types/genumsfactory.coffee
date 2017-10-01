import Random from 'random-js'
import Gene   from './gene'

encoding =
  0: 0
  1: 1
  2: 2
  3: 3
  4: 4
  5: 5
  6: 6
  7: 7
  8: 8
  9: 9
  10: 'A'
  11: 'B'
  12: 'C'
  13: 'D'
  14: 'E'
  15: 'F'
  16: 'G'
  17: 'H'
  18: 'I'
  19: 'J'
  20: 'K'
  21: 'L'
  22: 'M'
  23: 'N'
  24: 'O'
  25: 'P'
  26: 'Q'
  27: 'R'
  28: 'S'
  29: 'T'
  30: 'U'
  31: 'V'
  32: 'W'
  33: 'X'
  34: 'Y'
  35: 'Z'
  
decoding =
  0: 0
  1: 1
  2: 2
  3: 3
  4: 4
  5: 5
  6: 6
  7: 7
  8: 8
  9: 9
  A: 10
  B: 11
  C: 12
  D: 13  
  E: 14
  F: 15
  G: 16
  H: 17
  I: 18
  J: 19
  K: 20
  L: 21
  M: 22
  N: 23
  O: 24
  P: 25
  Q: 26
  R: 27
  S: 28
  T: 29
  U: 30
  V: 31
  W: 32
  X: 33
  Y: 34
  Z: 35
    
export default class GenumsFactory
  mt: null
  rands: 0
  
  constructor: (@data)->
    @seed = seed = @data.get 'seed'
    if !seed && seed != 0
      @seed = seed = Math.round(Math.random() * 2147483647)
      @data.set 'seed', seed
    
    @mt = Random.engines.mt19937()
    @mt.seed seed
  
  # generate a valid genum x blocks long
  generate: (bases)->
    return (@newNumber() while bases -= 1)
  
  # new number
  newNumber: ()->
    @rands++
    return Random.integer(0, 35)(@mt)
    
  # randomly mutate a genum
  mutate: (g = [], errorRate = 1/4)->
    mt = @mt    
    genums = g.slice 0
    
    @rands++
    while Random.real(0, 1)(mt) < errorRate
      @rands++
      switch Random.integer(0, 12)(mt)
        # swap
        when 0
          @rands++
          a = Random.integer(0, genums.length - 1)(mt) 
          @rands++
          b = Random.integer(0, genums.length - 1)(mt)
          z = genums[a]
          genums[a] = genums[b]
          genums[b] = z
        # insertion
        when 1, 2
          @rands++
          i = Random.integer(0, genums.length - 1)(mt)
          genums.splice i, 0, @newNumber()
        # remove
        when 3, 4
          @rands++
          i = Random.integer(0, genums.length - 1)(mt)
          genums.splice i, 1
        # mutate
        when 5, 6 ,7, 8 
          @rands++
          i = Random.integer(0, genums.length - 1)(mt)
          @rands++
          d = Random.integer(0, 4)(mt) - 2
          genums[i] = (genums[i] + d + 36) % 36
        #append
        when 9
          genums.push @newNumber()
        #prepend
        when 10
          genums.unshift @newNumber()
        # functional duplication, copy an existing gene        
        when 11
          genes = Gene.toGenes genums
          genesCount = genes.length
          @rands++
          i = Random.integer(0, genesCount - 1)(mt)
          
          @rands++
          j = Random.integer(0, genesCount - 1)(mt)
          
          genes.splice i, 0, genes[j]
          
          genums = []
          genums = genums.concat(gene.sequence) for gene in genes
       # shuffle genes
        when 12
          genes = Gene.toGenes genums
          genesCount = genes.length
          for i in [genesCount-1..1]
            @rands++
            j = Random.integer(0, i)(mt)
            [genes[i], genes[j]] = [genes[j], genes[i]]
          genums = [] 
          genums = genums.concat(gene.sequence) for gene in genes
      @rands++
          
    return genums
    
  @encode: (g)->
    str = ''
    for base in g
      str += encoding[base]
      
    return str
      
  @decode: (str)->
    g = []
    for ch in str 
      g.push decoding[ch]
      
    return g