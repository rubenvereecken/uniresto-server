winston = require 'winston'
userAgent = require 'express-useragent'
express = require 'express'
bodyParser = require 'body-parser'
favicon = require 'express-favicon'
cookieParser = require 'cookie-parser'
cookieSession = require 'cookie-session'
path = require 'path'
fs = require 'fs'
passport = require 'passport'

errors = require './errors'
utils = require './utils'
config = require './config'


setupGeneralMiddleware = (app) ->
  #app.use express.compress()
  app.use express.static path.join __dirname, '..', 'public'
  app.use express.static path.join __dirname, '..', 'design'

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
      maxAge: 24 * 60 * 60 * 1000 * 3
      secure: no
      overwrite: yes    # dev only
  app.use passport.initialize()
  app.use passport.session()
  #app.use reformatErrorsMiddleware

setupPassPhraseMiddleware = (app) ->
  app.use (req, res, next) ->
    passPhrase = req.query['passPhrase']
    req.passPhraseOK = passPhrase is config.passPhrase
    next()

module.exports = setupMiddleware = (app) ->
  {setupAuthMiddleware} = require './auth'
  setupGeneralMiddleware app
  setupAuthMiddleware app
  setupPassPhraseMiddleware app
  app

# TODO not really working very well so far
module.exports.setupReformatErrorsMiddleware = (app) ->
  app.use (err, req, res, next) ->
    #console.log err
    return res.send {type: "SyntaxError", message: err.body, code: err.status} if err instanceof SyntaxError
    if err?.name is 'ValidationError'
      fields = []
      fields.push path for path, val of err.errors
      err =
        code: 400
        fields: fields
        message: err.message
      return errors.badRequest res, err

    # todo investigate whether this is ok
    return errors[err.code] res if err.code
    return res.send res, err

module.exports.createAdminOnlyMiddleware = (methods=['POST', 'GET', 'PUT', 'OPTIONS', 'DELETE']) ->
  (req, res, next) ->
    if req.method in methods
      return errors.unauthorized res unless req.user
      return errors.forbidden res unless req.user.isAdmin()
    next()
