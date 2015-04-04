Menu = require 'models/Menu'

dishTemplate = require '/templates/admin/dish-edit'

module.exports = class EditMenuModal extends FrimFram.ModalView
  template: require '/templates/admin/menu-modal'
  savedDishes: null

  events:
    'click #save-menu': 'saveMenu'
    'click #new-dish': 'newDish'
    'click .remove-dish': 'removeDish'

  initialize: (cfg) ->
    # resto, menu, editMode (bool)
    _.extend @, cfg

    @savedDishes = FrimFram.storage.load 'savedDishes'

    @$el.on 'keypress', (e) =>
      if e.which is 13 and $('#menu-form').has(e.target).length
        @saveMenu()

  getContext: ->
    console.log @
    ctx = super
    ctx.resto = @resto
    ctx.menu = @menu
    ctx.editMode = @editMode
    ctx.savedDishes = @savedDishes
    ctx

  getInput: ->
    dishes = $('.dish').map (i, el) ->
      category: $(el).find('.dish-category').val()
      name: $(el).find('.dish-name').val()

    date: new Date $('#menu-date').val()
    dishes: dishes.get()

  newDish: ->
    $('#dishes').append dishTemplate()

  removeDish: (e) ->
    target = $(e.target)
    target.parents('.dish').remove()

  saveMenu: ->
    input = @getInput()
    @menu.set 'date', input.date
    @menu.fromFlatDishes input.dishes
    @menu.set 'resto', @resto?.id or @resto

    @savedDishes = ({category: dish.category, name: null} for dish in input.dishes)
    console.log @savedDishes
    FrimFram.storage.save 'savedDishes', @savedDishes

    success = (result) =>
      @trigger 'saved', result
      @hide()
    @menu.on 'sync', success
    @menu.save()

  onInsert: ->
    $ ->
      $('.date-picker').datepicker
        format: 'mm/dd/yyyy'
        daysOfWeekHighlighted: [1..5]
        orientation: 'left top'
        todayHighlight: yes
        autoclose: yes
