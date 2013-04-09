FactoryGirl.define do
  sequence(:username) { |n| "user_#{n}" }
  sequence(:email) { |n| "user_#{n}@example.com" }

  factory :player do
    username { generate(:username) }
    team
    signature { SecureRandom.urlsafe_base64(32) }
    title { SecureRandom.urlsafe_base64(12) }
    rep 0
    role "player"
    email { generate(:email) }
    password "password"
    points 0
    goals 0
    assists 0
    goals_against 0
    gaa 0.0
    ppg 0.0
    minutes_played 0.0
  end
end
