import Random from 'random-js'

export default class GenumsFactory
  mt: null
  
  constructor: (@data)->
    seed = @data.get 'seed'
    if !seed && seed != 0
      seed = Math.round(Math.random() * 2147483647)
      @data.set 'seed', seed
    
    @mt = Random.engines.mt19937()
    @mt.seed seed
  
  # generate a valid genum x blocks long
  generate: (x)->
    count = x * 3 + 1
    return (@newNumber() while count -= 1)
  
  # new number
  newNumber: ()->
    return Random.real(0, 10000)(@mt)
    
  # randomly mutate a genum
  mutate: (g = [], magicProbability = 1/10)->
    mt = @mt
    
    genums = g.slice 0
    
    while Random.real(0, 1)(mt) < magicProbability
      switch Random.integer(0, 9)(mt)
        # swap
        when 0
          a = Random.integer(0, genums.length - 1)(mt) 
          b = Random.integer(0, genums.length - 1)(mt)
          z = genums[a]
          genums[a] = genums[b]
          genums[b] = z
        # add
        when 1, 2
          i = Random.integer(0, genums.length - 1)(mt)
          genums.splice i, 0, @newNumber()
        # remove
        when 3, 4
          i = Random.integer(0, genums.length - 1)(mt)
          genums.splice i, 1
        # change
        when 5, 6, 7, 8
          i = Random.integer(0, genums.length - 1)(mt)
          genums[i] = @newNumber()
          
    return genums