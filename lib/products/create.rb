module Products
  class Create
    include CustomErrors

    def initialize(repo)
      @repo = repo
    end

    def call(params)
      product = Product.new(params['name'])
      raise ValidationError.new(product.errors) unless product.valid?

      @repo.add(product)
      product
    end
  end
end
