class UserRepository
  def initialize(store)
    @store = store
  end

  def add(user)
    @store.write(user.id, user)
  end

  def find_by_email(email)
    @store.all.find { |user| user.email == email }
  end
end
