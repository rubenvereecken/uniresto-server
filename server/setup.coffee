winston = require 'winston'
mongoose = require 'mongoose'
path = require 'path'

config = require './config'

module.exports.setupLogging = ->
  winston.remove winston.transports.Console

  if config.isProduction
    winston.add winston.transports.File,
      filename: path.join(process.cwd(), 'log', 'all.log')
      timestamp: true
      handleExceptions: true
      json: true
  else
    winston.add winston.transports.Console,
      colorize: true
      timestamp: true
      handleExceptions: false
      json: false
      level: 'debug'
    winston.debug 'Winston initialized to Console'

module.exports.connectToDatabase = ->
  connectionString = ->
    dbName = config.mongo.db
    address = config.mongo.host + ':' + config.mongo.port
    if config.mongo.username and config.mongo.password
      address = config.mongo.username + ':' + config.mongo.password + '@' + address
    address = "mongodb://#{address}/#{dbName}"

  address = connectionString()
  winston.info "Connecting to MongoDB with connection string #{address}"

  mongoose.connect address
  mongoose.connection.on 'error', (e) ->
    winston.error e
  mongoose.connection.once 'open', ->
    winston.info "Connection to #{address} successfully established"


module.exports.setupExpress = (app) ->
  for setting, value of config.express
    #console.log setting, value
    app.set setting, value

  setupMiddleware = require './middleware'
  setupRoutes = require './routes'
  setupMiddleware app
  setupRoutes app
  app
