require 'rails_helper'

RSpec.describe "Hiits", type: :request do
  describe "POST /hiits" do
    before do
      Life.create_and_start
      post "/hiits", params: { hiit: { roundCount: 10 } }
    end

    it "returns 201" do
      expect(response).to have_http_status(201)
    end

    it "creates a new hiit" do
      expect(Hiit.count).to eq 1
    end

    it "returns hiit info" do
      json = JSON.parse(response.body)
      hiit = Hiit.last
      
      expect(json["hiit"]).to eq hiit.info.stringify_keys
    end
  end
end
