Menu = require './Menu'

module.exports = class MenuCollection extends FrimFram.BaseCollection
  model: menu
  urlRoot: '/api/v1/restos/:restoId/menus'
