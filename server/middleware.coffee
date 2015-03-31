winston = require 'winston'
userAgent = require 'express-useragent'
express = require 'express'
bodyParser = require 'body-parser'
favicon = require 'express-favicon'
cookieParser = require 'cookie-parser'
cookieSession = require 'cookie-session'
#session = require 'express-session'
path = require 'path'
fs = require 'fs'
passport = require 'passport'

errors = require './errors'
utils = require './utils'
config = require './config'

reformatErrorsMiddleware = (err, req, res, next) ->
  return res.send {type: "SyntaxError", message: err.body, code: err.status} if err instanceof SyntaxError
  next()

setupGeneralMiddleware = (app) ->
  #app.use express.compress()
  app.use express.static path.join __dirname, '..', 'public'

  # TODO do I need this?
  app.use express.static path.join __dirname, '..', 'bower_components', 'bootstrap'
  app.use express.static path.join __dirname, '..', 'bower_components', 'flat-ui', 'dist'
  app.use favicon path.join __dirname, '../public','images','favicon.ico'

  app.use cookieParser() #config.cookieSecret
  app.use userAgent.express()
  app.use bodyParser.json()
  # need this bit to access form data apparently
  app.use bodyParser.urlencoded extended: yes
  app.use cookieSession
    secret:'2EqPfxTEqUtRXVfZygLR'
    cookie:
      #maxAge: 24 * 60 * 60 * 1000 * 3
      secure: no
      overwrite: yes    # dev only
  app.use passport.initialize()
  app.use passport.session()
  app.use reformatErrorsMiddleware


module.exports = setupMiddleware = (app) ->
  {setupAuthMiddleware} = require './auth'
  setupGeneralMiddleware app
  setupAuthMiddleware app
  app


module.exports.createAdminOnlyMiddleware = (methods=['POST', 'GET', 'PUT', 'OPTIONS', 'DELETE']) ->
  (req, res, next) ->
    if req.method in methods
      return errors.unauthorized res unless req.user
      return errors.forbidden res unless req.user.isAdmin()
    next()
