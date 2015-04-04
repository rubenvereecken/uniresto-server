mongoose = require 'mongoose'
log = require 'winston'

DishSchema = new mongoose.Schema
  byLanguage: [ new mongoose.Schema
    language:
      type: String
      default: 'en-US'
    name:
      type: String
      required: yes
    category:
      type: String
      required: yes
    , _id: no
  ]
  isProcessed:
    type: Boolean
    default: no
  split:
    type: [String]

do ->
  separators = ['with', 'and', 'on']

  defaultLang = 'en-us'

  DishSchema.pre 'save', (next) ->
    return next() if @get 'isProcessed'
    dish = _.find @get('byLanguage'), (d) -> d.language.toLowerCase() is defaultLang
    unless dish
      log.info "Did not found #{defaultLang} in dish #{@id}"
      return next()

    dish.name.split
    next()



MenuSchema = new mongoose.Schema
  dateCreated:
    type: Date
    default: Date.now
  date:
    type: Date
    required: yes
  resto:
    type: mongoose.Schema.Types.ObjectId
    ref: 'Resto'
    required: yes
  dishes: [DishSchema]


module.exports = Menu = mongoose.model 'Menu', MenuSchema
