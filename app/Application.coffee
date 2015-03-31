Router = require 'Router'
rootSchema = require 'schemas/root.schema'

Application = FrimFram.Application.extend({
  router: new Router()

  initialize: ->
    console.debug 'initializing app'
    authInit = require('lib/auth').init
    authInit()
    # any initialization goes in here

})

module.exports = Application
