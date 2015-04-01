module.exports = class Resto extends FrimFram.BaseModel
  urlRoot: '/api/v1/restos'
  idAttribute: '_id'

  readableLocation: ->
    loc = @get 'location'
    if loc.length is 0
      'n/a'
    else
      "#{loc[0]}, #{loc[1]}"
