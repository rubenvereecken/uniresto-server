menuRouter = require 'routers/menu'
restoRouter = require 'routers/resto'

module.exports = setupRoutes = (app) ->
  baseURL = '/v1'

  routers =
    '/restos/:restoId/menus': menuRouter

    '/restos': restoRouter


  middleware = {}
    #'/api/*': AuthMiddleware


  for route, mw of middleware
    app.use route, mw

  for route, router of routers
    app.use route, router

  app

