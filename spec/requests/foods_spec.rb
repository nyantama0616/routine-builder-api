require 'rails_helper'

RSpec.describe "Foods", type: :request do
  describe "GET /foods" do
    before do
      create_list(:food, 3)
      get "/foods"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns foods" do
      expect(response_body["foods"].length).to eq(Food.count)
      expect(response_body["foods"][0]).to eq Food.first.info.stringify_keys
    end 
  end

  describe "POST /foods" do
    before do
      @params = {
        food: {
          name: "food0",
          abb_name: "food",
          price: 100,
        }
      }
      post "/foods", params: @params, headers: headers_with_access_key
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "creates a food" do
      expect(Food.count).to eq 1
    end

    it "returns the created food" do
      expect(response_body["food"]).to eq Food.last.info.stringify_keys
    end

    it "returns 400 if params is invalid" do
      @params[:food][:name] = nil
      post "/foods", params: @params, headers: headers_with_access_key
      expect(response).to have_http_status(400)
    end

    it "access-keyなしでアクセスすると401を返す" do
      post "/foods", params: @params
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /foods/:id" do
    before do
      @food = create(:food)
      @params = {
        food: {
          name: "food100",
          abb_name: "foodX",
          price: 1000,
        }
      }
      patch "/foods/#{@food[:id]}", params: @params, headers: headers_with_access_key
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "updates the food" do
      info = Food.find(@food[:id]).info only: %i(name abb_name price)
      expect(info).to eq @params[:food]
    end

    it "returns the updated food" do
      expect(response_body["food"]).to eq @food.reload.info.stringify_keys
    end

    it "returns 400 if params is invalid" do
      @params[:food][:name] = nil
      patch "/foods/#{@food[:id]}", params: @params, headers: headers_with_access_key
      expect(response).to have_http_status(400)
    end

    it "returns 404 if food not found" do
      patch "/foods/0", params: @params, headers: headers_with_access_key
      expect(response).to have_http_status(404)
    end

    it "access-keyなしでアクセスすると401を返す" do
      patch "/foods/0", params: @params
      expect(response).to have_http_status(401)
    end
  end
end
