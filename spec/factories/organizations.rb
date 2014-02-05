# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization, :class => 'Organizations' do
    name "My Awesome organization"
    uuid { SecureRandom.uuid }
  end
end
