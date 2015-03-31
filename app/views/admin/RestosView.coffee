AdminView = require './AdminView'

module.exports = class RestosView extends AdminView
  id: 'restos-view'
  template: require 'templates/admin/restos'

  getContext: ->
    super
