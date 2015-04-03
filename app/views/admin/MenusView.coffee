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
    'click #new-menu': 'newMenu'

  initialize: ->
    super

    @listenTo @restos, 'sync', (restos) =>
      # fetch the first one even if nothing is selected.. yeah
      if restos.models.length > 0
        resto = restos.models[0]
        @resto = resto
        @menus.resto = resto
        @menus.fetch()

    @listenTo @menus, 'sync', @render
    @restos.fetch()

  renderRestos: ->
    console.debug 'renderRestos'
    restoSelect = @$el.find('#resto-select')
    restoSelect.children().remove()
    for resto in @restos.models
      restoSelect.append $ "<option>", value:resto.id, text: resto.get 'name'
    if @resto
      # yep this is manually selecting... madness. It's because we rerender the whole page
      restoSelect.select2 'val', @resto.id

  onRender: ->
    super
    console.debug 'onRender'
    @setupSelect2()
    @renderRestos()

  setupSelect2: ->
    $ =>
      $('#resto-select').select2
        dropdownCssClass: 'dropdown-inverse'
      $('#resto-select').on 'select2-selecting', =>
        @justSelected = true
        @onRestoSelection arguments...

  # why the f is this one necessary
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
    modal = new MenuModal menu: menu, resto: @resto, editMode: yes
    modal.show()
    @listenToOnce menu, 'sync', @render

  newMenu: (e) ->
    e.preventDefault()
    console.debug 'new menu'
    menu = new Menu
    modal = new MenuModal menu: menu, resto: @resto, editMode: yes
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
