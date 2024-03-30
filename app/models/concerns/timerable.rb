module Timerable
  extend ActiveSupport::Concern
  
  included do
    has_one :timer, as: :target, dependent: :destroy
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
