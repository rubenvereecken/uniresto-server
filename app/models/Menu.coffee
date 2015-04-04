module.exports = class Menu extends FrimFram.BaseModel
  idAttribute: '_id'
  urlRoot: ->
    "/api/v1/restos/#{@get 'resto'}/menus"

  formatDate: ->
    moment(@get 'date').format 'dddd DD/MM/YYYY'

  flattenDishes: (lang='en-us')->
    dishes = []
    for dish in @get('dishes') or []
      for locale in dish.byLanguage
        console.log locale
        if locale.language.toLowerCase() is lang
          dishes.push locale
          break


  fromFlatDishes: (dishes, defaultLang='en-US') ->
    newDishes = []
    for dish in dishes
      dish.language = defaultLang unless dish.language
      newDishes.push byLanguage: [dish]
    @set 'dishes', newDishes
    @
