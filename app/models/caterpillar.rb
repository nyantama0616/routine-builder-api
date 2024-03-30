class Caterpillar < ApplicationRecord
  include Timerable
  include ClassMethods

  belongs_to :life
  validates :life, presence: true
  validate :validate_pattern

  def info
    {
      pattern: pattern,
      passedSeconds: passed_seconds,
    }
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
