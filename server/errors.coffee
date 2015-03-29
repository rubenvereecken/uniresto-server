log = require 'winston'

defaults =
  401:
    message: 'Unauthorized'
  500:
    message: 'Internal Server Error'

makeError = (code, message) ->
  error = {}
  error = message if _.isObject message
  error.message = message unless _.isObject message
  error.code = code
  _.defaults error, defaults[code]
  error

errorNames =
  400: 'badRequest'
  401: 'unauthorized'
  403: 'forbidden'
  404: 'notFound'
  405: 'badMethod'
  408: 'clientTimeout'
  409: 'conflict'
  422: 'badInput'
  500: 'serverError'
  504: 'gatewayTimeout'

do ->
  for code, name of errorNames
    do (code, name) ->
      code = parseInt code
      module.exports[name] = (res, message) ->
        res.status code
        res.send makeError code, message
