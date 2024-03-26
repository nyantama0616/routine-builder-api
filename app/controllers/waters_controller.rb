class WatersController < ApplicationController
  def index
    life = Life.today
    render json: { amount: life.water_info }
  end

  def drink_water
    life = Life.today
    xml = params[:xml].to_i
    life.drink_water(xml)

    render json: { amount: life.water_info }
  end
end
