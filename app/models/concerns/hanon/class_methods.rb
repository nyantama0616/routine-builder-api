module Hanon::ClassMethods
  extend ActiveSupport::Concern

  HANON_NUM = 20
  PATTERN_NUM = 22
  SCALES = %w(C C# D D# E F F# G G# A A# B).map { |s| %w(m M).map { |t| "#{s}#{t}" } }.flatten

  class_methods do
    def create_and_start!(num, pattern)
      hanon = create!(
        num: num,
        pattern: pattern,
        life: Life.today,
      )
      hanon.create_timer
      hanon.timer.start
      hanon
    end
  end
end
