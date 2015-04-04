mongoose = require 'mongoose'
log = require 'winston'

IngredientSchema = new mongoose.Schema
  from:
    type: String
    required: yes
  to:
    type: Array[String]
