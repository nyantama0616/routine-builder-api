FactoryBot.define do
  factory :sleep do
    life

    after(:create) do |sleep|
      sleep.life.start
    end
  end
end
