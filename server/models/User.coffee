mongoose = require 'mongoose'
log = require 'winston'

UserSchema = new mongoose.Schema
  dateCreated:
    type: Date
    default: Date.now
  firstName:
    type: String
  lastName:
    type: String
  email:
    type: String


UserSchema.statics.fetchFacebookData


module.exports = User = mongoose.model 'User', UserSchema
