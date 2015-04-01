class User extends FrimFram.BaseModel
  @className: 'User'
  urlRoot: '/api/v1/user'
  idAttribute: '_id'

  isAdmin: ->
    'admin' in @get 'roles'

module.exports = User
