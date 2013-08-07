FactoryGirl.define do
  factory :substitution do
    game { FactoryGirl.create(:game) }
    on_time 0
    off_time 300
    team_id { self.game.home_team.id }
    player_id { self.game.home_team.players.first.id }
    gk false
    half 1
  end
end
