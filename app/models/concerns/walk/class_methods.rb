module Walk::ClassMethods
  extend ActiveSupport::Concern

  class_methods do
    def create_and_start!(from:, to:)
      life = Life.today
      walk = Walk.create!(life: life, from: from, to: to)
      walk.create_timer
      walk.timer.start
      walk
    end
  end
end
