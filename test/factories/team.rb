FactoryGirl.define do
  sequence(:seed) { |n| n }

  factory :team do
    season
    name { SecureRandom.urlsafe_base64 20 }
    short_name { SecureRandom.urlsafe_base64 8 }
    d1 true
    color { rand 0xffffff }
    points 0
    seed { generate(:seed) }
    wins 0
    losses 0
    ties 0
    overtime_wins 0
    overtime_losses 0

    after :create do |team|
      6.times do |i|
        FactoryGirl.create(:player, team: team, role: i == 0 ? "gm" : "player")
      end
    end
  end
end
