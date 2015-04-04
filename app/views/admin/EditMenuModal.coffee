Menu = require 'models/Menu'

dishTemplate = require '/templates/admin/dish-edit'

module.exports = class EditMenuModal extends FrimFram.ModalView
  template: require '/templates/admin/menu-modal'

  events:
    'click #save-menu': 'saveMenu'
    'click #new-dish': 'newDish'

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

  getInput: ->
    dishes = $('.dish').map (i, el) ->
      category: $(el).find('.dish-category').val()
      name: $(el).find('.dish-name').val()

    date: new Date $('#menu-date').val()
    dishes: dishes.get()

  newDish: ->
    $('#dishes').append dishTemplate()

  saveMenu: ->
    input = @getInput()
    @menu.set 'date', input.date
    @menu.fromFlatDishes input.dishes
    @menu.set 'resto', @resto?.id or @resto

    success = (result) =>
      @trigger 'saved', result
      @hide()
    @menu.on 'sync', success
    @menu.save()

  onInsert: ->
    $ ->
      console.log $('.date-picker').length
      $('.date-picker').datepicker
        format: 'mm/dd/yyyy'
        daysOfWeekHighlighted: [1..5]
        orientation: 'left top'
        todayHighlight: yes
        autoclose: yes
