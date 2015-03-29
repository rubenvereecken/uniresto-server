config = require './config'


module.exports = utils =

  isID: (id) -> _.isString(id) and id.length is 24 and id.match(/[a-f0-9]/gi)?.length is 24

  isAdmin: (req) ->
    passPhrase = req.get 'passPhrase'
    passPhrase is config.passPhrase
