class User extends FrimFram.BaseModel
  @className: 'User'
  urlRoot: '/api/v1/user'
  idAttribute: '_id'

  isAdmin: ->
    if @has 'roles' then 'admin' in @get 'roles' else no

module.exports = User
