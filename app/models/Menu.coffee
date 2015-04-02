module.exports = class Menu extends FrimFram.BaseModel
  idAttribute: '_id'
  urlRoot: ->
    "/api/v1/restos/#{@get 'resto'}/menus"
