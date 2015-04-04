express = require 'express'
router = express.Router()
log = require 'winston'

utils = require 'utils'
Menu = require 'models/Menu'
Resto = require 'models/Resto'
{createAdminOnlyMiddleware} = require 'middleware'
errors = require 'errors'

#router.use '/', createAdminOnlyMiddleware ['POST', 'PUT', 'PATCH', 'DELETE']

router.get '/', (req, res) ->
  Resto.find {}, (err, docs) ->
    return errors.serverError res, err if err
    res.send docs

router.post '/', (req, res) ->
  resto = new Resto req.body
  Resto.findOne {name: resto.name}, (err, r) ->
    return errors.conflict res, "Resto '#{resto.name}' already exists" if r
    resto.save (err) ->
      return errors.badRequest res, err if err
      res.send resto

router.put '/:nameOrId', (req, res) ->
  nameOrId = req.params['nameOrId']
  Resto.getByNameOrId nameOrId, (err, resto) ->
    return errors.serverError res, err if err
    return errors.notFound res, "Resto '#{nameOrId}' not found" unless resto
    resto.set key, val for key, val of req.body
    resto.save (err) ->
      return errors.badRequest res, err if err
      res.send resto

router.get '/:nameOrId', (req, res) ->
  nameOrId = req.params['nameOrId']
  Resto.getByNameOrId nameOrId, (err, resto) ->
    return errors.serverError res, err if err
    return errors.notFound res, "Resto '#{nameOrId}' not found" unless resto
    res.status(200).send resto

router.delete '/:nameOrId', (req, res) ->
  nameOrId = req.params['nameOrId']
  Resto.findOneAndRemove Resto.createNameOrIdQuery(nameOrId), (err, resto) ->
    return errors.serverError res, err if err
    return errors.notFound res, "Resto '#{nameOrId}' not found" unless resto
    res.send resto



module.exports = router
