class FoodsController < ApplicationController
  before_action :reject_if_unauthorized!, only: [:create, :update]

  def index
    foods = Food.all
    render json: { foods: foods.map(&:info) }
  end

  def create
    food = Food.new(create_params)
    logger.debug create_params

    if food.save
      logger.debug food.info
      render json: { food: food.info }
    else
      render json: { errors: food.errors.full_messages }, status: :bad_request
    end
  end

  def update
    food = Food.find_by(id: params[:id])

    unless food
      render json: { errors: ["food not found"] }, status: :not_found
      return
    end
      
    if food.update(update_params)
      render json: { food: food.info }
    else
      render json: { errors: food.errors.full_messages }, status: :bad_request
    end
  end

  private

  def create_params
    hash = params.require(:food).permit(:name, :abbName, :price)
    hash[:abb_name] = hash.delete(:abbName)
    hash
  end

  alias update_params create_params
end
