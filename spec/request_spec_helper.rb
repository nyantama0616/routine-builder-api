module RequestSpecHelper
  def response_body
    JSON.parse(response.body)
  end

  def headers_with_access_key
    { 'data-access-key' => ENV['ACCESS_KEY'] }
  end
end
