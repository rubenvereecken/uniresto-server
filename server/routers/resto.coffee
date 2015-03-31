express = require 'express'
router = express.Router()
log = require 'winston'

utils = require 'utils'
Menu = require 'models/Menu'
Resto = require 'models/Resto'
{createAdminOnlyMiddleware} = require 'middleware'
errors = require 'errors'

router.use createAdminOnlyMiddleware ['POST', 'PUT', 'PATCH', 'DELETE']

router.get '/', (req, res) ->
  Resto.find {}, (err, docs) ->
    return errors.serverError res, err if err
    res.send docs

router.post '/', (req, res) ->
  return errors.unauthorized res unless req.user
  return errors.forbidden res unless req.user.isAdmin()
  resto = new Resto req.body
  Resto.findOne {name: resto.name}, (err, r) ->
    return errors.conflict res, "Resto '#{resto.name}' already exists" if r
    resto.save (err) ->
      log.debug err if err
      return errors.badRequest res, err if err
      res.send resto

router.get '/:nameOrId', (req, res) ->
  nameOrId = req.param('nameOrId')
  Resto.getByNameOrId nameOrId, (err, resto) ->
    return errors.serverError res, err if err
    return errors.notFound res, "Resto '#{nameOrId}' not found" unless resto
    res.send resto

router.post '/:restoId/menus', (req, res) ->
  #language = req.get 'Content-Language'
  #errors.badRequest res, message: "Missing header", fields: ['Content-Language'] unless language
  return errors.badRequest res, message: "Empty body." unless req.body
  restoId = req.params['restoId']
  Resto.getByNameOrId restoId, (err, resto) ->
    return errors.serverError res, err if err
    return errors.notFound res, "Resto '#{restoId }' not found" unless resto
    Menu.findOne {date: req.body.date, resto: resto._id}, (err, menu) ->
      return errors.conflict res, "Menu at #{req.body.date} already exists for #{resto.name}" if menu
      menu = new Menu req.body
      menu.resto = resto._id
      menu.save (err) ->
        return errors.badRequest res, err if err
        menu.resto = resto
        res.send menu

router.put '/:restoId/menus', (req, res) ->
  #language = req.get 'Content-Language'
  #errors.badRequest res, message: "Missing header", fields: ['Content-Language'] unless language
  errors.badRequest res, message: "Empty body." unless req.body
  restoId = req.params['restoId']
  Resto.getByNameOrId restoId, (err, resto) ->
    return errors.serverError res, err if err
    return errors.notFound res, "Resto '#{restoId }' not found" unless resto
    Menu.findOne {date: req.body.date, resto: resto._id}, (err, menu) ->
      menu.dishes = req.body.dishes
      menu.save (err) ->
        return errors.badRequest res, err if err
        menu.resto = resto
        res.send menu

module.exports = router
