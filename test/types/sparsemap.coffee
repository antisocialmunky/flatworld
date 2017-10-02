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
    