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
