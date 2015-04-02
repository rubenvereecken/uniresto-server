AdminView = require './AdminView'
MenuCollection = require 'models/Menus'
RestoCollection = require 'models/Restos'
Resto = require 'models/Resto'
Menu = require 'models/Menu'
MenuModal = require './EditMenuModal'

module.exports = class MenusView extends AdminView
  id: 'menus-view'
  template: require 'templates/admin/menus'
  restos: new RestoCollection
  resto: null
  menus: new MenuCollection

  events:
    'click .remove-btn': 'removeMenu'
    'click .edit-btn': 'editMenu'
    'click .show-btn': 'showMenu'
    'click #new-resto': 'newMenuu'

  initialize: ->
    super

    @listenTo @restos, 'sync', (restos) =>
      console.debug 'restos syncd'

      if restos.models.length > 0
        resto = restos.models[0]
        #$('#resto-select').select2 'val', resto
        @menus.resto = resto
        @menus.fetch()

    @listenTo @menus, 'sync', @render
    @restos.fetch()

  renderRestos: ->
    restoSelect = @$el.find('#resto-select')
    restoSelect.children().remove()
    for resto in @restos.models
      restoSelect.append $ "<option>", value:resto.id, text: resto.get 'name'

  onRender: ->
    super
    console.debug 'onRender'
    @renderRestos()
    @setupSelect2()

  setupSelect2: ->
    $ =>
      $('#resto-select').select2
        dropdownCssClass: 'dropdown-inverse'
      $('#resto-select').on 'select2-selecting', => @onRestoSelection arguments...

  onInsert: ->
    console.debug 'onInsert'
    @setupSelect2()

  onRestoSelection: (e) ->
    console.debug 'on resto selection'
    @resto = @restos.get e.choice.id
    @menus.resto = @resto
    @menus.fetch()

  getContext: (e) ->
    ctx = super
    ctx.resto = @resto
    ctx.restos = @restos
    ctx.menus = @menus
    ctx

  editMenu: (e) ->
    e.preventDefault()
    $target = $(e.target)
    entry = $target.parents('.menu-entry')
    menuId = entry.data 'menu'
    menu = @menus.get(menuId)
    modal = new MenuModal menu: menu, resto: @resto, editMode: no
    modal.show()
    @listenToOnce menu, 'sync', @render

  newMenu: (e) ->
    e.preventDefault()
    menu = new Menu
    modal = new MenuModal menu: menu, resto: resto, editMode: no
    modal.show()
    @listenToOnce menu, 'sync', () =>
      @menus.add menu
      @render()

  removeMenu: (e) ->
    e.preventDefault()
    $target = $(e.target)
    entry = $target.parents('.menu-entry')
    menuId = entry.data 'menu'
    @menus.get(menuId).destroy()
    @render()
