AdminView = require './AdminView'
RestoCollection = require 'models/Restos'
Resto = require 'models/Resto'

module.exports = class RestosView extends AdminView
  id: 'restos-view'
  template: require 'templates/admin/restos'
  collection: new RestoCollection

  initialize: ->
    super arguments...


  getContext: ->
    super
