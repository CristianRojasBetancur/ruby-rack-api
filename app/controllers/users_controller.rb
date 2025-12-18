class UsersController
  include ResponseHelper
  include ParamsHelper
  include CustomErrors

  def create(env)
    params = body_params(env)
    user = Users::Create.new(USER_REPO).call(params)

    build_response({ user: user_data(user) }, 201)
  rescue ValidationError => e
    error_response(e.errors, 422)
  end

  private

  def user_data(user)
    { id: user.id, email: user.email }
  end
end
