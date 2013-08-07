require 'faker'

$playered = false

FactoryGirl.define do
  sequence(:username) { |n| "#{Faker::Name.name.parameterize}_#{n}" }
  sequence(:email) { |n| "user_#{n}@example.com" }

  factory :player do
    username {
      if $playered
        generate(:username)
      else
        $playered = true
        "otters"
      end
    }
    team
    signature { SecureRandom.urlsafe_base64(32) }
    title { SecureRandom.urlsafe_base64(12) }
    rep 0
    role "player"
    email { generate(:email) }
    confirmed_at { Time.now }
    password "password"
    points 0
    goals 0
    assists 0
    goals_against 0
    gaa 0.0
    ppg 0.0
    seconds_played 0
  end
end
