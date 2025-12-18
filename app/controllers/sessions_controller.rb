class SessionsController
  include ResponseHelper
  include ParamsHelper
  include ErrorsHandler

  def create(env)
    params = body_params(env)
    user = USER_REPO.find_by_email(params['email'])

    if user && user.authenticate_password!(params['password'])
      env['rack.session']['user_id'] = user.id

      build_response(response_data(env, user), 201)
    else
      error_data = build_error('unauthorized')

      error_response([error_data], 401)
    end
  end

  def delete(env)
    env['rack.session'].clear
    build_response({}, 204)
  end

  private

  def response_data(env, user)
    { user_id: user.id, email: user.email, expires_after: env['rack.session.options'][:expire_after] }
  end
end
