class WatersController < ApplicationController
  def drink_water
    life = Life.today
    xml = params[:xml].to_i
    life.drink_water(xml)

    render json: { amount: life.water_info }
  end
end
