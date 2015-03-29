winston = require 'winston'
userAgent = require 'express-useragent'
express = require 'express'
bodyParser = require 'body-parser'

errors = require './errors'
utils = require './utils'
config = require './config'

reformatErrorsMiddleware = (err, req, res, next) ->
  return res.send {type: "SyntaxError", message: err.body, code: err.status} if err instanceof SyntaxError
  next()

setupGeneralMiddleware = (app) ->
  app.use userAgent.express()
  app.use bodyParser.json()
  app.use reformatErrorsMiddleware

module.exports = setupMiddleware = (app) ->
  setupGeneralMiddleware app
  app


User = require 'models/User'

module.exports.AuthMiddleware = (req, res, next) ->
  token = req.get 'X-Access-Token'
  winston.debug 'Authing with token ' + token
  errors.unauthorized res unless token

  decoded = jwt.decode token, app.get('jwtTokenSecret')
  userID = decoded.iss
  expires = decoded.expires

  User.findById userID, (err, user) ->
    winston.log utils
    return errors.badInput res, "#{userID} is not an ID" unless utils.isID userID
    return errors.serverError res, err if err

module.exports.createAdminOnlyMiddleware = (methods=['POST', 'GET', 'PUT', 'OPTIONS', 'DELETE']) ->
  (req, res, next) ->
    console.log req.param('passPhrase'), config.passPhrase
    if req.method in methods
      passPhrase = req.param('passPhrase')
      return errors.unauthorized res, "Incorrect pass phrase, you're not getting in." if passPhrase isnt config.passPhrase
    next()
