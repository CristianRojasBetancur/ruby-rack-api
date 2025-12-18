module Support
  module ResponseSupport
    def response_data
      JSON.parse(last_response.body)['data']
    end

    def response_errors
      JSON.parse(last_response.body)['errors']
    end
  end
end
