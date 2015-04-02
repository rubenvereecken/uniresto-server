AdminView = require './AdminView'
MenuCollection = require 'models/Menus'
RestoCollection = require 'models/Restos'
Resto = require 'models/Resto'
Menu = require 'models/Menu'

module.exports = class MenusView extends AdminView
  id: 'menus-view'
  template: require 'templates/admin/menus'
  restos: new RestoCollection
  resto: null
  menus: new MenuCollection

  initialize: ->
    super

    @listenTo @restos, 'sync', (restos) ->
      restoSelect = @$el.find('#resto-select')
      restoSelect.children().remove()
      for resto in restos.models
        restoSelect.append "<option value=\"#{resto.id}\">#{resto.get 'name'}</option>"

    @listenTo @menus, 'sync', @render
    @restos.fetch()

  onRender: ->
    super
    $ =>
      $('#resto-select').select2
        dropdownCssClass: 'dropdown-inverse'

  onInsert: ->
    $ =>
      $('#resto-select').select2
        dropdownCssClass: 'dropdown-inverse'
        #placeholder: "Find a Resto"
      $('#resto-select').on 'select2-selecting', => @onRestoSelection arguments...

  onRestoSelection: (e) ->
    @resto = @restos.get e.choice.id
    @menus.resto = @resto
    @menus.fetch()

  getContext: (e) ->
    ctx = super
    ctx.resto = @resto
    ctx.restos = @restos
    ctx.menus = @menus
    ctx
