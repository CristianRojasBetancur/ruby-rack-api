class ProductsController
  include ResponseHelper
  include ParamsHelper

  def index(env)
    products = PRODUCT_REPO.all
    response_data = build_response_data(products)

    build_response({ products: response_data })
  end

  def create(env)
    job = CreateProductJob.perform(body_params(env))
    response_message = I18n.t('messages.enqueued')

    build_response({ message: response_message, job_id: job.id }, 202)
  end

  private

  def build_response_data(products)
    products.map { |product| { id: product.id, name: product.name } }
  end
end
