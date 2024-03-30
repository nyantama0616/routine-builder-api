module Timerable
  extend ActiveSupport::Concern
  
  included do
    has_one :timer, as: :target, dependent: :destroy
  end

  class_methods do
    def in_progress
      last = self.last
      if last && !last.timer.finished?
        last
      else
        nil
      end
    end

    def create_and_start!(**params)
      raise NotImplementedError, "You must implement #{self}##{__method__}"
    end
  end

  def start
    timer.start
  end

  def stop
    timer.stop
  end

  def finish
    timer.finish
  end

  def finished?
    timer.finished?
  end

  def passed_seconds
    timer&.passed_seconds.to_i
  end
end
