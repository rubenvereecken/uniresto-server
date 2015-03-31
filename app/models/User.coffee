class User extends FrimFram.BaseModel
  @className: 'User'
  urlRoot: '/api/v1/user'

  isAdmin: ->
    console.log @
    'admin' in @get 'roles'

module.exports = User
