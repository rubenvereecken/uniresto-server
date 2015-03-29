express = require 'express'
router = express.Router()
log = require 'winston'

utils = require 'utils'
Resto = require 'models/Resto'
{createAdminOnlyMiddleware} = require 'middleware'
errors = require 'errors'

router.use createAdminOnlyMiddleware ['POST']

router.post '/', (req, res) ->
  resto = new Resto req.body
  Resto.findOne {name: resto.name}, (err, r) ->
    return errors.conflict res, "Resto '#{resto.name}' already exists" if r
    resto.save (err) ->
      log.debug err if err
      errors.serverError res if err
      res.send resto

router.get '/:nameOrId', (req, res) ->
  nameOrId = req.param('nameOrId')
  Resto.getByNameOrId nameOrId, (err, resto) ->
    return errors.serverError res, err if err
    return errors.notFound res, "Resto '#{nameOrId}' not found" unless resto
    res.send resto

module.exports = router
