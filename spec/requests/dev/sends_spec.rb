require 'rails_helper'

RSpec.describe "Dev::Sends", type: :request do
  describe "post /dev/sends" do
    before do
      post "/dev/send", params: { message: "hello" }
      @log_file = Rails.root.join('log', 'sends', "#{Rails.env}.txt")
    end

    after do
      File.delete(@log_file) if File.exist?(@log_file)
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "log/sends/{environment}.txtにmessageが追記される" do
      expect(File.read(@log_file)).to eq "hello\n"
    end
  end
end
