class LifesController < ApplicationController
  def today
    life = Life.today
    render json: { life: life.info }
  end
end
