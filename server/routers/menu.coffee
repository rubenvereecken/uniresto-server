express = require 'express'
router = express.Router()
Menu = require 'models/Menu'
Resto = require 'models/Resto'
{createAdminOnlyMiddleware} = require 'middleware'
errors = require 'errors'

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
