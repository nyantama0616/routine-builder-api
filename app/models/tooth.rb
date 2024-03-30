class Tooth < ApplicationRecord
  include Timerable

  belongs_to :life

  class << self
    def create_and_start!
      life = Life.today
      tooth = Tooth.create!(life: life)
      tooth.create_timer
      tooth.start
      tooth
    end
  end
end
