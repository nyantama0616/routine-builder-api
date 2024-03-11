class ApplicationController < ActionController::API
  def authorized?
    request.headers['data-access-key'] == ENV['ACCESS_KEY']
  end
end
