import Block          from 'types/block'
import BodyBlock      from 'types/bodyblock'
import {
  minSize
  maxSize
  sizeRange
  minDistance
  maxDistance
  distanceRange
}                     from 'types/constants'
import Gene           from 'types/gene'
import GenumsFactory  from 'types/gene'
import GoBlock        from 'types/goblock'
import MuscleBlock    from 'types/muscleblock'
import Neuron         from 'types/neuron'
import Organism       from 'types/organism'
import Primeblock     from 'types/primeblock'
import HexGrid        from 'types/hexgrid'
import SparseMap      from 'types/sparsemap'
import { SparseList } from 'types/sparsemap'

# Classic exports
exports =
  Block:     Block
  BodyBlock: BodyBlock
  Constants:
    minSize:       minSize
    maxSize:       maxSize
    sizeRange:     sizeRange
    minDistance:   minDistance
    maxDistance:   maxDistance
    distanceRange: distanceRange
  Gene:          Gene
  GenumsFactory: GenumsFactory
  GoBlock:       GoBlock
  MuscleBlock:   MuscleBlock
  Neuron:        Neuron
  Organsim:      Organism
  Primeblock:    Primeblock
  HexGrid:       HexGrid
  SparseList:    SparseList
  SparseMap:     SparseMap
  
# for k,v of es
#  exports[k] = v

export default exports