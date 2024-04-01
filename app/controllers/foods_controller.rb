class FoodsController < ApplicationController
  before_action :reject_if_unauthorized!, only: [:create]

  def index
    foods = Food.all
    render json: { foods: foods.map(&:info) }
  end

  def create
    food = Food.new(create_params)

    if food.save
      render json: { food: food.info }
    else
      render json: { errors: food.errors.full_messages }, status: :bad_request
    end
  end

  private

  def create_params
    params.require(:food).permit(:name, :abb_name, :price)
  end
end
