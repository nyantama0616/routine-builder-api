class ApplicationController < ActionController::API
  def authorized?
    request.headers['data-access-key'] == ENV['ACCESS_KEY']
  end

  def reject_if_unauthorized!
    render json: { message: 'Unauthorized' }, status: :unauthorized unless authorized?
  end
end
