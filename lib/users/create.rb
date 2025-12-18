module Users
  class Create
    include CustomErrors

    def initialize(repo)
      @repo = repo
    end

    def call(params)
      user = User.new(params['email'], params['password'])
      raise ValidationError.new(user.errors) unless user.valid?

      user.set_password!(params['password'])
      @repo.add(user)
      user
    end
  end
end
