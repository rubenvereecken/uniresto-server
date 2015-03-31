passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
log = require 'winston'

User = require 'models/User'
config = require './config'
errors = require './errors'


module.exports.setupAuthMiddleware = (app) ->


  passport.serializeUser (user, done) ->
    done null, user._id

  passport.deserializeUser (id, done) ->
    User.findById id, (err, user) ->
      done err, user

  passport.use new LocalStrategy (username, password, done) ->
    User.findOne {username: username}, (err, user) ->
      return done err if err
      errorFields = []
      errorFields.push 'username' unless user
      errorFields.push 'password' if user and not user.validPassword password
      if errorFields.length
        return done null, false, {message: "Invalid login credentials", fields: errorFields}
      done null, user


  app.post '/auth/login', (req, res, next) ->
    console.log req.session
    passport.authenticate('local', (err, user, info) ->
      return next err if err
      unless user
        # little hack to still get in fields
        info.fields = ['username', 'password'] unless info.fields
        return errors.unauthorized res, info
      req.logIn user, (err) ->
        return next err if err
        res.send user
    )(req, res, next)

  log.debug 'Set up passport successfully'
