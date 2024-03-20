require 'rails_helper'

RSpec.describe Hiit, type: :model do
  describe "HIIT settings" do
    before do
      Hiit.work_time = 0
      Hiit.break_time = 0
      Hiit.round_count = 0
    end
  
    it "I can get hiit settings." do
      expect(Hiit.work_time).to eq 0
      expect(Hiit.break_time).to eq 0
      expect(Hiit.round_count).to eq 0
    end

    it "I can set hiit settings." do
      Hiit.work_time = 1
      Hiit.break_time = 2
      Hiit.round_count = 3
      expect(Hiit.work_time).to eq 1
      expect(Hiit.break_time).to eq 2
      expect(Hiit.round_count).to eq 3
    end
  end
end
