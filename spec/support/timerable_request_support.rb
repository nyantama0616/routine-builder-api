RSpec.shared_examples "timerable request" do |type|
  describe "timerable request" do
    it "returns timer info" do
      model = type.last
      expect(response_body["timer"]).to eq model.timer.info.as_json
    end

    it "returns todayLife" do
      expect(response_body["todayLife"]).to eq Life.today.info.as_json
    end
  end
end
