AdminView = require './AdminView'
RestoCollection = require 'models/Restos'
Resto = require 'models/Resto'
RestoModal = require './EditRestoModal'

module.exports = class RestosView extends AdminView
  id: 'restos-view'
  template: require 'templates/admin/restos'
  title: 'Admin | Resto'
  collection: new RestoCollection


  events:
    'click .remove-btn': 'removeResto'
    'click .edit-btn': 'editResto'
    'click #new-resto': 'newResto'

  initialize: ->
    super
    @collection.fetch success: (restos, res, opts) =>
      console.log restos
      @render()

  editResto: (e) ->
    e.preventDefault()
    $target = $(e.target)
    entry = $target.parents('.resto-entry')
    restoId = entry.data 'resto'
    resto = @collection.get(restoId)
    console.debug resto
    modal = new RestoModal resto
    modal.show()
    @listenToOnce modal, 'saved', (resto) =>
      @render()

  newResto: (e) ->
    e.preventDefault()
    resto = new Resto
    modal = new RestoModal resto
    modal.show()
    @listenToOnce modal, 'saved', (resto) =>
      @collection.add resto
      @render()

  removeResto: (e) ->
    e.preventDefault()
    $target = $(e.target)
    entry = $target.parents('.resto-entry')
    restoId = entry.data 'resto'
    console.debug restoId
    @collection.get(restoId).destroy()
    @render()

  getContext: ->
    ctx = super
    ctx.restos = @collection
    ctx

