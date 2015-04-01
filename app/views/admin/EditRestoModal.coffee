Resto = require 'models/Resto'

module.exports = class EditRestoModal extends FrimFram.ModalView
  template: require '/templates/admin/resto-modal'

  events:
    'click #save-resto': 'saveResto'

  initialize: (@resto, cfg={}) ->
    console.debug @resto
    _.extend @, cfg

  getContext: ->
    ctx = super
    console.debug 'getRender'
    ctx.resto = @resto
    ctx

  render: ->
    console.debug 'about to render'
    super

  saveResto: ->
    resto =
      name: @$el.find('#resto-name').val()
      address: @$el.find('#resto-address').val()
    lng = @$el.find('#longitude').val()
    lat = @$el.find('#latitude').val()
    if lng and lat
      resto.location = [lng, lat]

    success = (result) =>
      @trigger 'saved', result
      @hide()
    @resto.on 'sync', success
    @resto.save resto
