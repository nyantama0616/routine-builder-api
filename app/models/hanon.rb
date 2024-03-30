class Hanon < ApplicationRecord
  include ClassMethods
  include Timerable

  belongs_to :life
  
  validates :life, presence: true
  validate :validate_num
  validate :validate_pattern

  def info
    {
      num: num,
      pattern: pattern,
      passedSeconds: passed_seconds
    }
  end

  private

  def validate_num
    if num.blank?
      errors.add(:num, "must be present")
      return
    end

    if (1..HANON_NUM).exclude?(num)
      errors.add(:num, "must be 1-#{HANON_NUM}")
      return
    end
  end

  def validate_pattern
    if pattern.blank?
      errors.add(:pattern, "must be present")
      return
    end

    a = pattern.split ':'
    if a.length != 2
      errors.add(:pattern, "must be 2 parts")
      return
    end

    pattern_num = a[0].to_i
    if (1..PATTERN_NUM).exclude?(pattern_num)
      errors.add(:pattern, "pattern num must be 1-#{PATTERN_NUM}")
      return
    end

    scale = a[1]
    if SCALES.exclude?(scale)
      errors.add(:pattern, "scale must be #{SCALES.join(',')}")
      return
    end
  end
end
