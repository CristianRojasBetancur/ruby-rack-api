module ResponseHelper
  def error_response(errors, status = 400)
    [status, { "Content-Type" => "application/json" }, [{ 'errors' => errors.first }.to_json]]
  end

  def build_response(body, status = 200)
    [status, { "Content-Type" => "application/json" }, [{ 'data' => body }.to_json]]
  end
end
