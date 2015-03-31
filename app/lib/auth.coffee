User = require 'models/User'

module.exports.init = ->
  console.debug 'userObject ' + window.userObject
  if window.userObject
    module.exports.me = window.me = new User window.userObject
