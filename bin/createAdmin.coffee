path = require 'path'
mongoose = require 'mongoose'
env = require 'node-env-file'

baseDir = path.join __dirname, '..'
env path.join baseDir, '.env'

config = require '../server/config'
{connectToDatabase} = require 'setup'

connectToDatabase (db) ->
  User = require '../server/models/User'

  adminObj =
    username: process.env.UNIR_ADMIN_USERNAME or 'uniresto'
    password: process.env.UNIR_ADMIN_PASSWORD or 'uniresto'
    roles: ['admin']

  admin = new User adminObj

  admin.save (err) ->
    if err
      console.log err
      process.exit 1
    else
      console.log "Created admin user #{admin.get 'username'} successfully"
      process.exit 0
