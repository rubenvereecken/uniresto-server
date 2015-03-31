User = require 'models/User'

module.exports = class AdminView extends FrimFram.RootView
  className: 'admin-page'

  shortcuts:
    'enter': -> console.log arguments

  events:
    'click #login': 'loginAdmin'

  constructor: ->
    super
    @$el.on 'keypress', (e) =>
      if e.which is 13 and $('#login-form').has(e.target).length
        @loginAdmin()

  loginAdmin: ->
    username = @$el.find('#username').val()
    password = @$el.find('#password').val()

    jqxhr = $.post '/auth/login',
      {
        username: username
        password: password
      }, (user) =>
        console.log user
        window.me = new User user
        @render()

    jqxhr.fail (res) =>
      response = JSON.parse res.responseText
      for field in ['username', 'password']
        @$el.find("##{field}").parent().removeClass 'has-error'

      for field in response.fields
        console.debug field
        @$el.find("##{field}").parent().addClass 'has-error'

  getContext: ->
    ctx = super
    ctx.me = window.me
    ctx
