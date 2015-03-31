mongoose = require 'mongoose'
log = require 'winston'
crypto = require 'crypto'

config = require 'server/config'

UserSchema = new mongoose.Schema
  dateCreated:
    type: Date
    default: Date.now
  username:
    type: String
    unique: yes
  roles:
    type: [String]
    enum: ['admin']
  passwordHash: type: String
,
  strict: false

UserSchema.pre 'save', (next) ->
  password = @get 'password'
  @set 'passwordHash', User.hashPassword(password)
  @set 'password', undefined
  next()

UserSchema.statics.hashPassword = (password) ->
  password = password.toLowerCase()
  shasum = crypto.createHash('sha512')
  shasum.update config.salt + password
  shasum.digest 'hex'

UserSchema.methods.validPassword = (password) ->
  hashed = User.hashPassword password
  hashed is @get 'passwordHash'

UserSchema.methods.toJSON = ->
  obj = @toObject()
  delete obj.passwordHash
  obj

UserSchema

module.exports = User = mongoose.model 'User', UserSchema
