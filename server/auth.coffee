passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
log = require 'winston'

User = require 'models/User'
config = require './config'
errors = require './errors'


module.exports.setupAuthMiddleware = (app) ->
  app.use passport.initialize()

  passport.serializeUser (user, done) ->
    done null, user._id

  passport.deserializeUser (id, done) ->
    User.findById id, done

  passport.use new LocalStrategy (username, password, done) ->
    User.findOne {username: username}, (err, user) ->
      return done err if err
      return done null, false, message: "Incorrect username" unless user
      return done null, false, message: "Incorrect password" unless user.validPassword password
      done null, user

  # need this bit to access form data apparently
  bodyParser = require 'body-parser'
  app.use bodyParser.urlencoded extended: yes

  app.post '/auth/login', (req, res, next) ->
    log.debug req.body
    log.debug req.xhr
    passport.authenticate('local', (err, user, info) ->
      return next err if err
      return errors.unauthorized res, message: info.message unless user
      res.send user
    )(req, res, next)

  log.debug 'Set up passport successfully'
