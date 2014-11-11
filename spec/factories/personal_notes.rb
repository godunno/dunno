# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :personal_note do
    description "Aplicar prova surpresa"
    done false
    event nil
  end
end
