log = require 'winston'
path = require 'path'

env = process.env

module.exports = config = {}
config.title = 'VUB Resto'
config.passPhrase = env.PASS_PHRASE

config.mongo =
  port: env.UNIR_MONGO_PORT or 27017
  host: env.UNIR_MONGO_HOST or 'localhost'
  db: env.UNIR_MONGO_DB or 'uniresto'
  username: env.UNIR_MONGO_USERNAME or ''
  password: env.UNIR_MONGO_PASSWORD or ''

config.isProduction = config.mongo.host isnt 'localhost'  # could be better I suppose
config.cookieSecret = config.UNIR_COOKIE_SECRET or 'shakeallthelamas'

config.express =
  port: env.UNIR_PORT or 3030
  env: env.NODE_ENV or if config.isProduction then 'production' else 'development'
  title: config.title
  'strict routing': false
  'case sensitive routing': false
  'json spaces': 2 # prettify json


module.exports = config
