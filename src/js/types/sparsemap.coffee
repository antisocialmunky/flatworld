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
      i = @keys[kI]
      if x?
        return @list[i] = x
      else
        delete @list['' + i]
        @keys.splice kI, 1
        
        return x
    
    # if not found
        
    if x == undefined
      return x
      
    # hendle special case of inserting before 0
    if kI < 0
      @keys.unshift searchKey
    else
      @keys.splice kI, 0, searchKey
      
    @list[searchKey] = x
    
    return x
    
  
  # delete an element
  delete: (searchKey)->
    @set searchKey, undefined
      
  # search for a specific element and return
  get: (searchKey) ->
    [kI, found] = @_getKeyIndex searchKey
    
    return null if !found
    
    return @list[@keys[kI]]
    
  # clone so it works with map
  _getForMap: (searchKey)->
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
        #console.log 'Found ', searchKey, '@', currentIndex
        return [currentIndex, true]
    #console.log 'Not found ', searchKey, '@', currentIndex
    return [Math.ceil(insertIndex), false]
    
  # dump list to array with offset
  toArray: (def = 0)->
    if @keys.length == 0
      return [[], 0]
      
    keys = @keys
    list = @list
          
    arr = []
    offset = keys[0]
    
    for i in [offset..keys[keys.length - 1]]
      if list[i]?
        arr.push list[i]
      else
        arr.push def
        
    return [arr, offset]

export default class SparseMap extends SparseList
  constructor: ()->
    super()
    
  # set an element
  set: (searchKey1, searchKey2, x)->
    list = @_getForMap searchKey1
    
    if list?
      return list.set searchKey2, x

    list = new SparseList()
    list.set searchKey2, x
    super searchKey1, list
    
    return x
    
  # search for a specific element and return
  get: (searchKey1, searchKey2) ->
    list = super searchKey1
    
    if list?
      return list.get searchKey2
    
    return undefined
    
  # delete an element
  delete: (searchKey1, searchKey2)->
    @set searchKey1, searchKey2, undefined
    
  toMatrix: (def=0)->
    if @keys.length == 0
      return [[], 0, 0]
      
    keys = @keys
    list = @list
          
    ars = []
    mat = []
    offsetX = keys[0]
    offsetY = undefined
    maxY = 0
    
    # get lists
    for i in [offsetX..keys[keys.length - 1]]
      if list[i]?
        ars.push list[i].toArray(def)
      else
        ars.push [[], 0]
        
    # get offsetY and maxY
    for arr in ars
      if !offsetY?
        offsetY = arr[1]
      else if arr[1] < offsetY 
        offsetY = arr[1]
      if offsetY + arr[0].length > maxY
        maxY = offsetY + arr[0].length
        
    # display final padded matrix
    for arr in ars
      do (arr)->
        ar = arr[0]
        #console.log 'left pad', (arr[1] - offsetY), arr
        for i in [1..(arr[1] - offsetY)] by 1
          ar.unshift def
          
        #console.log 'right pad', (maxY - arr[0].length - offsetY)
        for i in [-1..(maxY - arr[0].length - offsetY)] by 1
          ar.push def
        mat.push ar
              
    return [mat, offsetX, offsetY ? 0]