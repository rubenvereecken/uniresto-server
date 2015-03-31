Resto = require './Resto'

module.exports = class RestoCollection extends FrimFram.BaseCollection
  url: '/api/v1/restos'
  model: Resto
