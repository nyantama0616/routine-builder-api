class Caterpillar < ApplicationRecord
  class << self
    def create_and_start!(pattern)
      life = Life.today
      caterpillar = create!(life: life, pattern: pattern)
      timer = Timer.create!(target: caterpillar)
      timer.start
      caterpillar
    end
  end
  
  belongs_to :life
  has_one :timer, as: :target, dependent: :destroy
  validates :life, presence: true
  validate :validate_pattern

  def info
    {
      pattern: pattern,
      passedSeconds: timer&.passed_seconds,
    }
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

  #TODO: いる？
  def finished?
    timer.finished?
  end

  private

  def validate_pattern
    if pattern.blank?
      errors.add(:pattern, "must be present")
      return
    end
    errors.add(:pattern, "must be unique 4 digits") unless pattern.chars.map(&:to_i).uniq.length == 4
    errors.add(:pattern, "must be 1-4") unless pattern.match?(/\A[1-4]+\z/)
  end
end
