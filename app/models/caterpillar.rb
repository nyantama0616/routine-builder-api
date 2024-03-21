class Caterpillar < ApplicationRecord
  class << self
    def create_and_start!(pattern)
      life = Life.today
      create!(life: life, pattern: pattern, started_at: Time.current)
    end
  end
  
  belongs_to :life
  validates :life, presence: true
  validate :validate_pattern

  def info
    {
      pattern: pattern,
      startedAt: started_at,
      finishedAt: finished_at
    }
  end

  def finish
    raise 'already finished' if finished_at.present?
    update(finished_at: Time.current)
  end

  def has_finished?
    finished_at.present?
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
