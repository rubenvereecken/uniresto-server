menuRouter = require 'routers/menu'
restoRouter = require 'routers/resto'

module.exports = setupRoutes = (app) ->
  baseURL = '/api/v1'

  routers =
    '/restos': restoRouter
    #'/restos/:restoId/menus': menuRouter


  middleware = {}
    #'/api/*': AuthMiddleware


  for route, mw of middleware
    app.use route, mw

  for route, router of routers
    app.use baseURL + route, router

  app

