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

module.exports.connectToDatabase = (done) ->
  connectionString = ->
    dbName = config.mongo.db
    address = config.mongo.host + ':' + config.mongo.port
    if config.mongo.username and config.mongo.password
      address = config.mongo.username + ':' + config.mongo.password + '@' + address
    address = "mongodb://#{address}/#{dbName}"

  address = connectionString()
  winston.info "Connecting to MongoDB with connection string #{address}"

  db = mongoose.connect address

  mongoose.connection.on 'error', (e) ->
    winston.error e
  mongoose.connection.once 'open', ->
    winston.info "Connection to #{address} successfully established"
    done db if done


setupFrontend = (app) ->
  fs = require 'fs'
  path = require 'path'
  #- Serve index.html
  try
    mainHTML = fs.readFileSync(path.join(__dirname, '../public', 'index.html'), 'utf8')
  catch e
    winston.error "Error modifying index.html: #{e}"

  app.all '*', (req, res) ->
    # insert the user object directly into the html so the application can have it immediately. Sanitize </script>
    console.log 'serving index'
    jsonifiedUser = JSON.stringify(req.user?.toJSON())
    data = mainHTML.replace(/"userObjectTag"/g, jsonifiedUser)
    # TODO production settings
    res.header 'Cache-Control', 'no-cache, no-store, must-revalidate'
    res.header 'Pragma', 'no-cache'
    res.header 'Expires', 0
    res.status(200).send data

module.exports.setupExpress = (app) ->
  for setting, value of config.express
    #console.log setting, value
    app.set setting, value

  setupMiddleware = require './middleware'
  setupRoutes = require './routes'
  {setupReformatErrorsMiddleware} = require './middleware'

  setupMiddleware app
  setupRoutes app
  setupReformatErrorsMiddleware app
  setupFrontend app
  app
