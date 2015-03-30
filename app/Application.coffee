Router = require 'Router'
rootSchema = require 'schemas/root.schema'

Application = FrimFram.Application.extend({
  router: new Router()

  initialize: ->
    # any initialization goes in here

})

module.exports = Application
