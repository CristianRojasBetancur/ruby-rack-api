require 'rack/session'
require 'securerandom'
require 'debug'
require 'bcrypt'
require 'dotenv'

ENV['RACK_ENV'] ||= 'development'

Dotenv.load(".env.#{ENV['RACK_ENV']}", '.env')

require_relative 'initializers/i18n'
require_relative 'initializers/scalar'

Dir[File.join(__dir__, '../app/models/concerns/**/*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, '../app/models/*.rb')].sort.each { |file| require file }

require_relative '../db/memory_store'

Dir[File.join(__dir__, '../app/repositories/**/*.rb')].sort.each { |file| require file }

require_relative '../app/helpers/errors_handler'
require_relative '../app/helpers/response_helper'
require_relative '../app/helpers/params_helper'

Dir[File.join(__dir__, '../lib/**/*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, '../app/jobs/**/*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, '../app/middleware/**/*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, '../app/controllers/**/*.rb')].sort.each { |file| require file }

require_relative '../app/application'
require_relative 'routes'

PRODUCT_STORE = MemoryStore.new
USER_STORE    = MemoryStore.new
JOB_STORE    = MemoryStore.new

PRODUCT_REPO = ProductRepository.new(PRODUCT_STORE)
USER_REPO    = UserRepository.new(USER_STORE)
JOB_REPO    = JobRepository.new(JOB_STORE)
