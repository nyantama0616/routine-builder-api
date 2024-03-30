require 'rails_helper'

RSpec.describe Tooth, type: :model do
  it_behaves_like 'timerable', Tooth, -> { Tooth.create_and_start! }

  before do 
    Life.create_and_start
    @tooth = Tooth.create_and_start!
  end

  it "belongs to life" do
    life = Life.today
    expect(@tooth.life).to eq life
  end

  it "invalid if life_id is empty" do
    @tooth.life_id = nil
    expect(@tooth).to be_invalid
  end
end
