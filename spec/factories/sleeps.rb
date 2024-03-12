FactoryBot.define do
  factory :sleep do
    life { Life.create_and_start }
  end
end
