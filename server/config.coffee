log = require 'winston'
path = require 'path'

env = process.env

module.exports = config = {}
config.title = 'VUB Resto'
config.passPhrase = env.PASS_PHRASE

config.mongo =
  port: env.VUBR_MONGO_PORT or 27017
  host: env.VUBR_MONGO_HOST or 'localhost'
  db: env.VUBR_MONGO_DB or 'vubresto'
  username: env.VUBR_MONGO_USERNAME or ''
  password: env.VUBR_MONGO_PASSWORD or ''

config.isProduction = config.mongo.host isnt 'localhost'  # could be better I suppose

config.express =
  port: env.VUBR_PORT or 3030
  env: env.NODE_ENV or if config.isProduction then 'production' else 'development'
  title: config.title
  'strict routing': false
  'case sensitive routing': false
  'json spaces': 2 # prettify json


module.exports = config
