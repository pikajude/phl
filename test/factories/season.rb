FactoryGirl.define do
  factory :season do
    name "Season 9"
    season_number 9
    start_date { Date.commercial(Date.today.year, Date.today.cweek, 1) - 2.weeks }
    end_date { Date.commercial(Date.today.year, Date.today.cweek, 1) + 4.weeks }
  end
end
