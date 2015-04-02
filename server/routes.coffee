log = require 'winston'
fs = require 'fs'
path = require 'path'
_ = require 'lodash'

menuRouter = require 'routers/menu'
restoRouter = require 'routers/resto'
errors = require './errors'

module.exports = setupRoutes = (app) ->
  baseURL = '/api/v1'

  routers =
    '/restos': [restoRouter, menuRouter]

  for route, routerPack of routers
    if _.isArray routerPack
      app.use baseURL + route, router for router in routerPack
    else
      app.use baseURL + route, routerPack

  app.use baseURL, (req, res) ->
    return errors.notFound res, "Route #{req.method} #{req.path} unknown. Sorry mate."


  app

