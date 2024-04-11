class Walk < ApplicationRecord
  include Timerable
  include ClassMethods
  
  belongs_to :life

  validates :life, presence: true
  validate :validate_from_to

  def info
    {
      passedSeconds: passed_seconds,
    }
  end

  private

  def validate_from_to
    %i(from to).each do |attr|
      if send(attr).blank?
        errors.add(attr, "must be present")
        return
      end

      # Placeに含まれていない場合はエラー
      unless Walk::Place.constants.map { |c| Walk::Place.const_get(c) }.include?(send(attr))
        errors.add(attr, "must be #{Walk::Place.constants.join(',')}")
        return
      end
    end

    if from == to
      errors.add(:to, "and from must not be same")
      return
    end
  end
end
