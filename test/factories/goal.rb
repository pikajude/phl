FactoryGirl.define do
  factory :goal do
    game { FactoryGirl.create(:game) }
    team_id { self.game.home_team_id }
    time 0
    half 1
  end
end
