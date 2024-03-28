class HomesController < ApplicationController
  def index
    render json: { todayLife: Life.today.info }
  end
end
