express = require 'express'
router = express.Router()
Menu = require 'models/Menu'
Resto = require 'models/Resto'
errors = require 'errors'
log = require 'winston'

router.get '/:restoId/menus', (req, res) ->
  from = req.query.from
  end = req.query.until
  q = {}
  if from or end
    q.date = {}
    q.date.$gte = new Date from   if from
    q.date.$lte = new Date end    if end
  restoId = req.params['restoId']
  Resto.getByNameOrId restoId, (err, resto) ->
    return errors.serverError res, err if err
    return errors.notFound res, "Resto '#{restoId }' not found" unless resto
    q.resto = resto._id
    log.debug q
    log.debug 'about to search menus'
    Menu.find q, (err, menus) ->
      return errors.serverError res, err if err
      res.send menus

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
      menu.set 'resto', resto._id
      menu.save (err) ->
        return errors.badRequest res, err if err
        menu.set 'resto', resto # populate manually
        res.send menu

router.put '/:restoId/menus', (req, res) ->
  return errors.unauthorized res, "Neither admin nor does passPhrase check out" unless req.user?.isAdmin() or req.passPhraseOK
  errors.badRequest res, message: "Empty body." unless req.body
  restoId = req.params['restoId']
  Resto.getByNameOrId restoId, (err, resto) ->
    return errors.serverError res, err if err
    return errors.notFound res, "Resto '#{restoId }' not found" unless resto
    Menu.findOne {date: req.body.date, resto: resto._id}, (err, menu) ->
      return errors.serverError res if err
      if menu   # update
        menu.set 'dishes', req.body.dishes
      else
        menu = new Menu req.body
      menu.set 'resto', resto._id
      log.debug req.body
      log.debug menu.toJSON()
      menu.save (err) ->
        return errors.badRequest res, err if err
        menu.set 'resto', resto   # populate for return
        res.send menu


module.exports = router
