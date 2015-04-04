module.exports = class Menu extends FrimFram.BaseModel
  idAttribute: '_id'
  urlRoot: ->
    "/api/v1/restos/#{@get 'resto'}/menus"

  formatDate: (format='MM/DD/YYYY') ->
    moment(@get 'date').format format

  flattenDishes: (lang='en-us')->
    dishes = []
    for dish in @get('dishes') or []
      for locale in dish.byLanguage
        if locale.language.toLowerCase() is lang
          dishes.push locale
          break
    dishes


  fromFlatDishes: (dishes, defaultLang='en-US') ->
    newDishes = []
    for dish in dishes
      dish.language = defaultLang unless dish.language
      newDishes.push byLanguage: [dish]
    @set 'dishes', newDishes
    @
