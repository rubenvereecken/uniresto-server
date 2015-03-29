mongoose = require 'mongoose'
log = require 'winston'

RestoSchema = new mongoose.Schema
  dateAdded:
    type: Date
    default: Date.now
  name:
    type: String
    unique: yes
    required: yes
  address:
    type: String
    required: yes
  location:
    type: [Number]  # this is for MongoDB to guarantee ordering

RestoSchema.methods.toJSON = ->
  obj = @toObject()
  delete obj._id
  delete obj.__v
  obj

RestoSchema.statics.getByNameOrId = (nameOrId, callback) ->
  mongoose.model('Resto').findOne [{_id: nameOrId}, {name: nameOrId}], callback

module.exports = Resto = mongoose.model 'Resto', RestoSchema
