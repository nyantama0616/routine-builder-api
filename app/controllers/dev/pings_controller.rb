class Dev::PingsController < ApplicationController
  def index
    render json: { message: 'pong', authorized: authorized? }
  end
end
