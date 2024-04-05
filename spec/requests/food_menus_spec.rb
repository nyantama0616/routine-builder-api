require 'rails_helper'

RSpec.describe "FoodMenus", type: :request do
  describe "GET /food_menus" do
    before do
      @food_menu = create(:food_menu)
      @foods = create_list(:food, 3)
      @foods.each do |food|
        @food_menu.add_food(food.id, 1)
      end
      
      get '/food_menus'
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns food_menus" do
      food_menu = response_body["foodMenus"][0]
      expect(food_menu).to eq @food_menu.info(only: %i(id name foods)).deep_stringify_keys
    end
  end

  describe "GET /food_menus/:id" do
    before do
      @foods = create_list(:food, 3)
      @food_menu = FoodMenu.create_menu!(name: "menu0", foods: @foods.map { |food| {id: food.id, quantity: 1} })
      
      get "/food_menus/#{@food_menu[:id]}"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns the food menu" do
      food_menu_json = response_body["foodMenu"]
      expect(food_menu_json).to eq @food_menu.info.deep_stringify_keys
    end

    it "returns 404 if food menu not found" do
      get "/food_menus/0"
      expect(response).to have_http_status(404)
    end
  end

  describe "POST /food_menus" do
    before do
      @foods = create_list(:food, 3)
      @params = {
        foodMenu: {
          name: "menu1",
          foods: @foods.map { |food| {id: food.id, quantity: 1} }
        }
      }
      
      post '/food_menus', params: @params, headers: headers_with_access_key
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "creates a food menu" do
      food_menu = FoodMenu.last
      expect(food_menu.name).to eq @params[:foodMenu][:name]
    end

    it "menu has foods" do
      food_menu = FoodMenu.last
      expect(food_menu.foods.length).to eq @foods.length
    end

    it "returns the food menu" do
      food_menu_json = response_body["foodMenu"]
      food_menu = FoodMenu.last
      expect(food_menu_json).to eq food_menu.info.deep_stringify_keys
    end

    it "access-key is required" do
      FoodMenu.last.destroy
      post '/food_menus', params: @params
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /food_menus/:id" do
    before do
      @foods0 = create_list(:food, 3)
      @food_menu = FoodMenu.create_menu!(name: "menu0", foods: @foods0.map { |food| {id: food.id, quantity: 1} })

      @foods1 = create_list(:food, 3)
      @params = {
        foodMenu: {
          name: "menu1",
          foods: @foods1.map { |food| {id: food.id, quantity: 1} }
        }
      }

      patch "/food_menus/#{@food_menu[:id]}", params: @params, headers: headers_with_access_key
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "updates the food menu name" do
      food_menu = FoodMenu.find(@food_menu[:id])
      expect(food_menu.name).to eq @params[:foodMenu][:name]
    end

    it "updates the food menu foods" do
      food_menu = FoodMenu.find(@food_menu[:id])
      food_menu.foods.each_with_index do |food, i|
        expect(food.id).to eq @foods1[i].id
      end
    end

    it "returns the food menu" do
      food_menu_json = response_body["foodMenu"]
      food_menu = FoodMenu.find(@food_menu[:id])
      expect(food_menu_json).to eq food_menu.info.deep_stringify_keys
    end

    it "access-key is required" do
      patch "/food_menus/#{@food_menu[:id]}", params: @params
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /food_menus/:id/delete" do
    before do
      @foods = create_list(:food, 3)
      @food_menu = FoodMenu.create_menu!(name: "menu0", foods: @foods.map { |food| {id: food.id, quantity: 1} })
      
      delete "/food_menus/#{@food_menu[:id]}", headers: headers_with_access_key
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "deletes the food menu" do
      expect(FoodMenu.find_by(id: @food_menu[:id])).to be_nil
    end

    it "access-key is required" do
      food_menu = FoodMenu.create_menu!(name: "menu0", foods: @foods.map { |food| {id: food.id, quantity: 1} })
      delete "/food_menus/#{food_menu[:id]}"
      expect(response).to have_http_status(401)
    end
  end
end
