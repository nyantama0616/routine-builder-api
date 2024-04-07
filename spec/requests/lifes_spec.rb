require 'rails_helper'

RSpec.describe "Lifes", type: :request do
  describe "GET /lifes/today" do
    before do
      Life.create_and_start
      get "/lifes/today"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns life info" do
      expect(response_body["life"]).to eq Life.today.info.as_json
    end
  end
end
