mongoose = require 'mongoose'
log = require 'winston'
utils = require 'utils'

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
    #lng lat
    type: [Number]  # this is for MongoDB to guarantee ordering

RestoSchema.methods.toJSON = ->
  obj = @toObject()
  #delete obj._id
  delete obj.__v
  obj

RestoSchema.statics.getByNameOrId = (nameOrId, callback) ->
  q = Resto.createNameOrIdQuery nameOrId
  mongoose.model('Resto').findOne q, callback

RestoSchema.statics.createNameOrIdQuery = createNameOrIdQuery = (nameOrId) ->
  if utils.isId nameOrId
    _id: new mongoose.Types.ObjectId(nameOrId)
  else
    name: nameOrId

module.exports = Resto = mongoose.model 'Resto', RestoSchema
