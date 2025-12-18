require 'rack'
require 'minitest/autorun'
require 'rack/test'

ENV['RACK_ENV'] ||= 'test'

require_relative '../config/boot'

Dir[File.join(__dir__, 'support/**/*.rb')].each { |f| require f }

module TestApp
  def app
    Rack::Builder.new do
      use Rack::Static,
          urls: ['/openapi.yml', '/AUTHORS'],
          root: '.',
          header_rules: [
            [
              'openapi.yml',
              {
                'Cache-Control' => 'no-store, no-cache, must-revalidate, max-age=0',
                'Pragma' => 'no-cache',
                'Expires' => '0'
              }
            ],
            [
              'AUTHORS',
              {
                'Cache-Control' => "public, max-age=#{24 * 3600}"
              }
            ]
          ]

      use Rack::Session::Cookie, secret: ENV['SESSION_SECRET'], key: '_rack_session', expire_after: 3600
      use Authentication
      use Rack::Deflater
      run Application.new
    end
  end
end
