# Neuron type to make setting these up easier
export default class Neuron
  bias: 0
  activationFn: null

  constructor: (@bias, @activationFn)->