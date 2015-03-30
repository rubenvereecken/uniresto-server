log = require 'winston'
fs = require 'fs'
path = require 'path'

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

  #- Serve index.html
  try
    mainHTML = fs.readFileSync(path.join(__dirname, '../public', 'index.html'), 'utf8')
  catch e
    log.error "Error modifying index.html: #{e}"

  app.all '*', (req, res) ->
    # todo change for production
    # insert the user object directly into the html so the application can have it immediately. Sanitize </script>
#      data = mainHTML.replace('"userObjectTag"', JSON.stringify(UserHandler.formatEntity(req, req.user)).replace(/\//g, '\\/'))
    res.header 'Cache-Control', 'no-cache, no-store, must-revalidate'
    res.header 'Pragma', 'no-cache'
    res.header 'Expires', 0
    res.send 200, mainHTML

  app

