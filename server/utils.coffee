config = require './config'
mongoose = require 'mongoose'


module.exports = utils =

  isID: (id) -> _.isString(id) and id.length is 24 and id.match(/[a-f0-9]/gi)?.length is 24

  isAdmin: (req) ->
    passPhrase = req.get 'passPhrase'
    passPhrase is config.passPhrase

  toObjectId: (id) ->
    unless id instanceof mongoose.Types.ObjectId
      id = new mongoose.Types.ObjectId(id)
    id
