log = require 'winston'
fs = require 'fs'
path = require 'path'
_ = require 'lodash'

menuRouter = require 'routers/menu'
restoRouter = require 'routers/resto'

module.exports = setupRoutes = (app) ->
  baseURL = '/api/v1'

  routers =
    '/restos': [restoRouter, menuRouter]
    #'/restos': menuRouter


  middleware = {}
    #'/api/*': AuthMiddleware


  for route, mw of middleware
    app.use route, mw

  for route, routerPack of routers
    if _.isArray routerPack
      app.use baseURL + route, router for router in routerPack
    else
      app.use baseURL + route, routerPack



  app

