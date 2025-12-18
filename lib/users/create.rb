module Users
  class Create
    include CustomErrors
    include Support

    def initialize(repo)
      @repo = repo
    end

    def call(params)
      if @repo.find_by_email(params['email'])
        error_data = build_error_data('unique', 'user', { field: 'email' })

        raise ValidationError.new([error_data])
      end

      user = User.new(params['email'], params['password'])
      raise ValidationError.new(user.errors) unless user.valid?

      user.set_password!(params['password'])
      @repo.add(user)
      user
    end
  end
end
