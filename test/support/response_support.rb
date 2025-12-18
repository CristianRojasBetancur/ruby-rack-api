module Support
  module ResponseSupport
    def response_data
      JSON.parse(last_response.body)['data']
    end

    def error_response
      JSON.parse(last_response.body)['errors']
    end
  end
end
