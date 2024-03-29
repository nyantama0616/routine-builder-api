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

    def all_patterns
      res = {}

      (1..HANON_NUM).each do |num|
        x = {}
        (1..PATTERN_NUM).each do |pattern_num|
          SCALES.each do |scale|
            pattern = "#{pattern_num}:#{scale}"
            x[pattern] = 0
          end
        end
        res[num] = x
      end

      Hanon.all.each do |hanon|
        res[hanon.num][hanon.pattern] += hanon.timer&.passed_seconds.to_i
      end

      res
    end

    def in_progress
      hanon = Hanon.last
      if hanon && !hanon.timer.finished?
        hanon
      else
        nil
      end
    end
  end
end
