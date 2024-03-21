FactoryBot.define do
  factory :caterpillar do
    pattern { "1234" }
    life { Life.today }
  end
end
