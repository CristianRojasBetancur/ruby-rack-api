module ParamsHelper
  include ResponseHelper
  include ErrorsHandler

  def body_params(env)
    req = Rack::Request.new(env)
    body = req.body.read

    req.body.rewind
    return {} if body.empty?

    JSON.parse(body)
  rescue JSON::ParserError
    error_data = build_error("bad_request")

    error_response([error_data])
  end

  def query_params(env)
    binding.break
    Rack::Utils.parse_query(env['QUERY_STRING'])
  end
end
