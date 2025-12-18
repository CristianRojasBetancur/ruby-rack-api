require 'scalar_ruby'

Scalar.setup do |config|
  config.page_title = 'Awesome Rack API'
  config.specification = File.read('openapi.yml')
  config.scalar_configuration = { theme: 'laserwave' }
end
