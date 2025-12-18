module Support
  module RequestsSupport
    def post_user(body)
      post '/users',
           body.to_json,
           headers
    end

    def post_product(body)
      post '/products',
           body.to_json,
           headers
    end

    def post_session(body)
      post '/sessions',
           body.to_json,
           headers
    end

    def delete_session
      delete '/sessions',
             headers
    end

    def get_job(job_id)
      get "/jobs/#{job_id}",
          headers
    end

    def api_credentials
      email, password = 'user@example.com', 'validPassword123'
      repo = UserRepository.new(USER_STORE)
      user = User.new(email, password)

      user.set_password!(password)
      repo.add(user)
      post_session({ email: email, password: password })
    end

    private

    def headers
      { 'CONTENT_TYPE' => 'application/json' }
    end
  end
end