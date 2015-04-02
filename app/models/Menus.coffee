Menu = require './Menu'

module.exports = class MenuCollection extends FrimFram.BaseCollection
  model: Menu
  resto: null
  url: ->
    "/api/v1/restos/#{@resto?.id or @resto}/menus"
