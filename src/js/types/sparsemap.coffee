export class SparseList
  # dictionary of array indices to   
  list: null
  # store the keys of the list in sorted order for log(n) retrieval
  keys: null
  
  constructor: (list, offset = 0)->
    @list = {}
    @keys = []
    
    if list?
      for x, i in list
        @set i + offset, x  
       
  # set an element
  set: (searchKey, x)->
    [kI, found] = @_getKeyIndex searchKey
    
    # if found
    if found
      i = @keys[@kI]
      if x?
        return @list[i] = x
      else
        @keys.splice kI, 1
        delete @list[i]
        
        return x
    
    # if not found
    
    if !x?
      return x
      
    # hendle special case of inserting before 0
    if kI < 0
      @keys.unshift searchKey
    else
      @keys.splice kI, 0, searchKey
      
    @list[searchKey] = x
    
    return x
      
  # search for a specific element and return
  get: (searchKey) ->
    [kI, found] = @_getKeyIndex searchKey
    
    return null if !found
    
    return @list[@keys[kI]]

  # search for a specific element index or nearest index
  _getKeyIndex: (searchKey) ->
    keys = @keys
    
    minIndex = 0
    maxIndex = keys.length - 1
    
    insertIndex  = (minIndex + maxIndex) / 2 ? 0
    currentIndex = Math.round insertIndex
    currentKey   = null
        
    shiftRight = false

    while minIndex <= maxIndex
      currentKey = keys[currentIndex]

      if currentKey < searchKey
        minIndex = currentIndex + 1
        insertIndex  = (minIndex + maxIndex) / 2 ? 0
        currentIndex = Math.ceil(insertIndex)
      else if currentKey > searchKey
        maxIndex = currentIndex - 1
        insertIndex  = (minIndex + maxIndex) / 2 ? 0
        currentIndex = Math.floor(insertIndex)
      else
        console.log 'Found ', searchKey, '@', currentIndex
        return [currentIndex, true]
    console.log 'Not found ', searchKey, '@', currentIndex
    return [Math.ceil(insertIndex), false]
    
  map: ()->

export default class SparseMap extends SparseList
  constructor: ()->
    super