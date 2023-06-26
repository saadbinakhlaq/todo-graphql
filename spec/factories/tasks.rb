FactoryBot.define do
  factory :task do
    name { "MyString" }
    association :list
    done { false }
  end
end
