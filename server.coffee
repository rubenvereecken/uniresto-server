env = require 'node-env-file'

express = require 'express'
http = require 'http'
log = require 'winston'
setup = require './server/setup'

GLOBAL._ = require 'lodash'

module.exports.start = ->
  app = createExpressApp()
  http.createServer(app).listen app.get 'port'
  log.info 'Express server listening on port ' + app.get('port')
  GLOBAL.app = app
  app

createExpressApp = ->
  setup.setupLogging()
  setup.connectToDatabase()

  app = express()
  setup.setupExpress app
  log.debug "Set up express"
  app
