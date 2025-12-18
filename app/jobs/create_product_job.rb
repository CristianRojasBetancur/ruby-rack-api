class CreateProductJob
  include CustomErrors

  def self.perform(attrs)
    job = Job.new
    JOB_REPO.add(job)

    AsyncProcessor.call(5) do
      product = Products::Create.new(PRODUCT_REPO).call(attrs)

      job.success(product.id) if product.valid?
    rescue ValidationError => e
      job.failure(e.errors)
    end

    job
  end
end
