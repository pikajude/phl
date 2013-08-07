FactoryGirl.define do
  factory :game do
    season { FactoryGirl.create(:season) }
    home_team { FactoryGirl.create(:team, :season_id => self.season_id) }
    away_team { FactoryGirl.create(:team, :season_id => self.season_id) }
    order 1
    played_on Time.now
    week 1
    day 1
    substitution_count 0
    overtime false
    finished true
    reported false
    home_score 0
    away_score 0
    length 600
  end
end
