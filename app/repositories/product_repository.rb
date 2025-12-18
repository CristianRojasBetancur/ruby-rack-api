class ProductRepository
  def initialize(store)
    @store = store
  end

  def add(product)
    @store.write(product.id, product)
  end

  def all
    @store.all
  end
end
