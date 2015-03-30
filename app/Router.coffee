NotFoundView = require('views/NotFoundView')
go = FrimFram.Router.go

class Router extends FrimFram.Router

  #- Routing map
  
  routes:
    '': go('HomeView')

    'admin': go 'admin/HomeView'

    'api/v1/*path': 'routeToServer'

    'file/*path': 'routeToServer'
    
    '*name': 'showNotFoundView'
    
  showNotFoundView: ->
    @openView new NotFoundView()

module.exports = Router
