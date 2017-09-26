pkg = require './package.json'

module.exports =
  site:
    title: pkg.name + ' v' + pkg.version