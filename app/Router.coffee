NotFoundView = require('views/NotFoundView')
go = FrimFram.Router.go

class Router extends FrimFram.Router

  #- Routing map
  
  routes:
    '': go('HomeView')

    'admin': go 'admin/HomeView'
    'admin/restos': go 'admin/RestosView'

    'api/v1/*path': 'routeToServer'

    'file/*path': 'routeToServer'
    
    '*name': 'showNotFoundView'
    
  showNotFoundView: ->
    @openView new NotFoundView()

module.exports = Router
