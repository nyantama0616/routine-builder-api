class FoodMenusController < ApplicationController
  before_action :reject_if_unauthorized!, only: %i(create update)

  def index
    @food_menus = FoodMenu.all.map { |food_menu| food_menu.info(only: %i(id name)) }
    render json: { foodMenus: @food_menus }
  end

  def show
    if food_menu = FoodMenu.find_by(id: params[:id])
      render json: { foodMenu: food_menu.info }
    else
      render json: { errors: ["FoodMenu not found"] }, status: 404
    end
  end

  def create
    begin
      food_menu = FoodMenu.create_menu!(**create_params)
      render json: { foodMenu: food_menu.info}
    rescue => e
      render json: { errors: [e.message] }, status: 400
    end
  end

  #TODO: 最適化する
  def update
    if food_menu = FoodMenu.find(params[:id])
      begin
        food_menu.update_menu!(**update_params)
        render json: { foodMenu: food_menu.info }
      rescue => e
        render json: { errors: [e.message] }, status: 400
      end
    else
      render json: { errors: ["FoodMenu not found"] }, status: 404
    end
  end

  private

  def create_params
    params.require(:foodMenu).permit(:name, foods: %i(id quantity)).to_h.deep_symbolize_keys
  end

  alias :update_params :create_params
end
