FactoryBot.define do
  message_array = ["Test message 1", "Here is my message", "Hello world, of course"]
  pubkeys = ["00:00:00", "0"]

  factory :random_user, class: User do
    name { Faker::Name.first_name }
    pubkey { pubkeys.sample }
  end
end
