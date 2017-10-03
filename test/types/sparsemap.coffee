{ SparseList, SparseMap } = require '../lib/types'

expect = require('chai').expect

describe 'SparseList', ->
  it 'should instantiate default', ->
    list = new SparseList()
    expect(list.list).to.exist
    expect(list.keys).to.exist
  
  it 'should instantiate with a list', ->
    list = new SparseList([10,20,30,40])
    expect(list.list).to.deep.eq
      '0': 10
      '1': 20
      '2': 30
      '3': 40
      
    expect(list.keys).to.deep.eq [0, 1, 2, 3]
    
  it 'should instantiate with a list with a positive offset', ->
    list = new SparseList([10,20,30,40], 2)
    expect(list.list).to.deep.eq
      '2': 10
      '3': 20
      '4': 30
      '5': 40
      
    expect(list.keys).to.deep.eq [2, 3, 4, 5]
    
  it 'should instantiate with a list with a negative offset', ->
    list = new SparseList([10,20,30,40], -2)
    expect(list.list).to.deep.eq
      '-2': 10
      '-1': 20
      '0': 30
      '1': 40
      
    expect(list.keys).to.deep.eq [-2, -1, 0, 1]
    
  it 'should instantiate with an unsorted list', ->
    list = new SparseList([40,20,30,10])
    expect(list.list).to.deep.eq
      '0': 40
      '1': 20
      '2': 30
      '3': 10
      
    expect(list.keys).to.deep.eq [0, 1, 2, 3]
    
  it 'should set unsorted values', ->
    list = new SparseList()
    list.set -1, 'A'
    list.set  3, 'B'
    list.set  0, 'C'
    list.set  2, 'D'
    list.set -2, 'E'
    
    expect(list.list).to.deep.eq
      '-1': 'A'
      '3' : 'B'
      '0' : 'C'
      '2' : 'D'
      '-2': 'E'
      
    expect(list.keys).to.deep.eq [-2, -1, 0, 2, 3]
    
  it 'should set existing values', ->
    list = new SparseList()
    list.set -1, 'A'
    list.set  3, 'B'
    list.set  0, 'C'
    list.set  2, 'D'
    list.set -2, 'E'
    list.set  0, 'Z'
    
    expect(list.list).to.deep.eq
      '-1': 'A'
      '3' : 'B'
      '0' : 'Z'
      '2' : 'D'
      '-2': 'E'
      
    expect(list.keys).to.deep.eq [-2, -1, 0, 2, 3]
    
  it 'should set undefined values correctly', ->
    list = new SparseList()
    list.set -1, 'A'
    list.set  3, 'B'
    list.set  0, 'C'
    list.set  2, 'D'
    list.set -2, 'E'
    
    list.set -2, undefined
    
    expect(list.list).to.deep.eq
      '-1': 'A'
      '3' : 'B'
      '0' : 'C'
      '2' : 'D'
      
    expect(list.keys).to.deep.eq [-1, 0, 2, 3]
    
  it 'should delete values correctly', ->
    list = new SparseList()
    list.set -1, 'A'
    list.set  3, 'B'
    list.set  0, 'C'
    list.set  2, 'D'
    list.set -2, 'E'
    
    list.delete 2
    
    expect(list.list).to.deep.eq
      '-1': 'A'
      '3' : 'B'
      '0' : 'C'
      '-2': 'E'
      
    expect(list.keys).to.deep.eq [-2, -1, 0, 3]
    
  it 'should get values correctly', ->
    list = new SparseList()
    list.set  0, 'Q'
    
    q = list.get 0
    
    q.should.eq 'Q'
    
  it 'should get undefined values correctly', ->
    list = new SparseList()
    list.set  0, 'Q'
    
    q = list.get 1
    
    expect(q).to.not.exist
    
  it 'should toArray values 0 based indices correctly', ->
    list = new SparseList()
    list.set 0, 'A'
    list.set 1, 'B'
    list.set 2, 'C'
    list.set 3, 'D'
    list.set 4, 'E'
        
    [arr, offset] = list.toArray()
    arr.should.deep.eq ['A', 'B', 'C', 'D', 'E']
    offset.should.eq 0
  
  it 'should toArray values positive based indices correctly', ->
    list = new SparseList()
    list.set 10, 'A'
    list.set 11, 'B'
    list.set 12, 'C'
    list.set 13, 'D'
    list.set 14, 'E'
        
    [arr, offset] = list.toArray()
    arr.should.deep.eq ['A', 'B', 'C', 'D', 'E']
    offset.should.eq 10
    
  it 'should toArray values with negative indices correctly', ->
    list = new SparseList()
    list.set -1, 'A'
    list.set  3, 'B'
    list.set  0, 'C'
    list.set  2, 'D'
    list.set -2, 'E'
        
    [arr, offset] = list.toArray()
    arr.should.deep.eq ['E', 'A', 'C', 0, 'D', 'B']
    offset.should.eq -2   
    
  it 'should toArray with default value', ->
    list = new SparseList()
    list.set 0, 'A'
    list.set 3, 'B'
        
    [arr, offset] = list.toArray 'Z'
    arr.should.deep.eq ['A', 'Z', 'Z', 'B']
    offset.should.eq 0   
    
  it 'should toArray empty list', ->
    list = new SparseList()
        
    [arr, offset] = list.toArray 'Z'
    arr.should.deep.eq []
    offset.should.eq 0   
    
describe 'SparseMap', ->
  it 'should instantiate default', ->
    map = new SparseMap()
    
  it 'should get/set', ->
    map = new SparseMap()
    map.set 5, 5, 'A'
    
    a = map.get 5, 5
    a.should.eq 'A'
    
  it 'should not get non-existent', ->
    map = new SparseMap()
    map.set 5, 5, 'A'
    
    x = map.get 5, 15
    expect(x).to.not.exist
    
  it 'should toMatrix values correctly', ->
    map = new SparseMap()    
    map.set 0, 0, 'Z'
    map.set 1, 1, 'A'
    map.set 2, 2, 'B'
    map.set 3, 3, 'C'
    map.set 2, 5, 'D'
     
    [mat, offsetX, offsetY] = map.toMatrix()
    offsetX.should.eq 0
    offsetY.should.eq 0
    mat.should.deep.eq [
      ['Z', 0, 0, 0, 0, 0]
      [0, 'A', 0, 0, 0, 0]
      [0, 0, 'B', 0, 0, 'D']
      [0, 0, 0, 'C', 0, 0]
    ]
    
  it 'should toMatrix values with positive based indices correctly', ->
    map = new SparseMap()    
    map.set 1, 1, 'Z'
    map.set 2, 2, 'A'
    map.set 3, 3, 'B'
    map.set 4, 4, 'C'
    map.set 3, 6, 'D'
     
    [mat, offsetX, offsetY] = map.toMatrix()
    offsetX.should.eq 1
    offsetY.should.eq 1
    mat.should.deep.eq [
      ['Z', 0, 0, 0, 0, 0]
      [0, 'A', 0, 0, 0, 0]
      [0, 0, 'B', 0, 0, 'D']
      [0, 0, 0, 'C', 0, 0]
    ]
    
  it 'should toMatrix values with negative based indices correctly', ->
    map = new SparseMap()    
    map.set -1, -1, 'Z'
    map.set 0, 0, 'A'
    map.set 1, 1, 'B'
    map.set 2, 2, 'C'
    map.set 1, 4, 'D'
     
    [mat, offsetX, offsetY] = map.toMatrix()
    offsetX.should.eq -1
    offsetY.should.eq -1
    mat.should.deep.eq [
      ['Z', 0, 0, 0, 0, 0]
      [0, 'A', 0, 0, 0, 0]
      [0, 0, 'B', 0, 0, 'D']
      [0, 0, 0, 'C', 0, 0]
    ]
    
  it 'should toMatrix default values correctly', ->
    map = new SparseMap()    
    map.set 0, 0, 'Z'
    map.set 1, 1, 'A'
    map.set 2, 2, 'B'
    map.set 3, 3, 'C'
    map.set 2, 5, 'D'
     
    [mat, offsetX, offsetY] = map.toMatrix(1)
    offsetX.should.eq 0
    offsetY.should.eq 0
    mat.should.deep.eq [
      ['Z', 1, 1, 1, 1, 1]
      [1, 'A', 1, 1, 1, 1]
      [1, 1, 'B', 1, 1, 'D']
      [1, 1, 1, 'C', 1, 1]
    ]
    
  it 'should toMatrix empty map', ->
    map = new SparseMap()    
     
    [mat, offsetX, offsetY] = map.toMatrix()
    offsetX.should.eq 0
    offsetY.should.eq 0
    mat.should.deep.eq []
    