module.exports = errors =
  init: ->
    notyDefaults =
      timeout: 5000
      theme: 'relax'
      layout: 'bottomRight'

    _.extend $.noty.defaults, notyDefaults

    $( document ).ajaxError errors.globalAjaxError

  globalAjaxError: (event, jqxhr, settings) ->
    errors.ajaxError jqxhr

  ajaxError: (jqxhr) ->
    console.log jqxhr
    if jqxhr.responseText
      response = JSON.parse jqxhr.responseText
      text =
        "#{jqxhr.statusText} (#{jqxhr.status}): #{response.message}"
    else
      text =
        "#{jqxhr.statusText} (#{jqxhr.status}): Summat bad happened, not quite sure what"
    n = noty
      text: text
      type: 'error'

