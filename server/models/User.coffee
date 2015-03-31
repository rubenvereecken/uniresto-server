mongoose = require 'mongoose'
log = require 'winston'
crypto = require 'crypto'

config = require 'config'

UserSchema = new mongoose.Schema
  dateCreated:
    type: Date
    default: Date.now
  username: type: String
  passwordHash: type: String
,
  strict: false

UserSchema.pre 'save', (next) ->
  password = @get 'password'
  @set('passwordHash', User.hashPassword(password))
  @set 'password', undefined

UserSchema.statics.hashPassword = (password) ->
  password = password.toLowerCase()
  shasum = crypto.createHash('sha512')
  shasum.update config.salt + password
  shasum.digest 'hex'

UserSchema.methods.validPassword = (password) ->
  hashed = User.hashPassword password
  console.log @get 'passwordHash'
  hashed is @get 'passwordHash'

module.exports = User = mongoose.model 'User', UserSchema
