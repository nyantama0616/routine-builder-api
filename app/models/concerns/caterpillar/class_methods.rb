module Caterpillar::ClassMethods
  extend ActiveSupport::Concern

  class_methods do
    def create_and_start!(pattern)
      life = Life.today
      caterpillar = create!(life: life, pattern: pattern)
      timer = Timer.create!(target: caterpillar)
      timer.start
      caterpillar
    end

    #各パターンの練習時間を取得
    def all_patterns
      res = {}
      
      "1234".chars.permutation.map(&:join).each do |pattern|
        res[pattern] = 0
      end

      Caterpillar.all.each do |cat|
        res[cat.pattern] += cat.timer&.passed_seconds.to_i
      end

      res
    end
  end
end
