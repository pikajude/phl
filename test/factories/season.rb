FactoryGirl.define do
  factory :season do
    ignore do
      schedule false
    end

    name "Season 9"
    season_number 9
    start_date { Date.commercial(Date.today.year, Date.today.cweek, 1) - 2.weeks }
    end_date { Date.commercial(Date.today.year, Date.today.cweek, 1) + 4.weeks }

    after(:create) do |season, evaluator|
      FactoryGirl.create_list(:team, 10, season: season)
      season.schedule! if evaluator.schedule
    end
  end
end
