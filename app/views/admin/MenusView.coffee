AdminView = require './AdminView'
MenuCollection = require 'models/Menus'
Menu = require 'models/Menu'

module.exports = class MenusView extends AdminView
  id: 'menus-view'
  template: require 'templates/admin/menus'
