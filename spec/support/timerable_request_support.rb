RSpec.shared_examples "timerable request" do |type|
  describe "timerable request" do
    it "returns timer info" do
      model = type.last
      expect(response_body["timer"]).to eq model.timer.info.as_json
    end

    it "returns status" do
      expect(response_body["status"]).to eq Life.today.status
    end
  end
end
