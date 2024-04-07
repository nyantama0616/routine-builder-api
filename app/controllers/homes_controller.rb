class HomesController < ApplicationController
  def index
    render json: { status: Life.today.status }
  end
end
