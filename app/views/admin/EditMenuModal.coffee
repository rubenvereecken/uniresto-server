Menu = require 'models/Menu'

module.exports = class EditMenuModal extends FrimFram.ModalView
  template: require '/templates/admin/menu-modal'

  events:
    'click #save-menu': 'saveMenu'

  initialize: (cfg) ->
    # resto, menu, editMode (bool)
    _.extend @, cfg

    @$el.on 'keypress', (e) =>
      if e.which is 13 and $('#menu-form').has(e.target).length
        @saveMenu()

  getContext: ->
    console.log @
    ctx = super
    ctx.resto = @resto
    ctx.menu = @menu
    ctx.editMode = @editMode
    ctx

  onInsert: ->
    $ ->
      console.log $('.date-picker').length
      $('.date-picker').datepicker
        format: 'mm/dd/yyyy'
        daysOfWeekHighlighted: [1..5]
        orientation: 'left top'
        todayHighlight: yes
        autoclose: yes
