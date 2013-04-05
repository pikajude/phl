Delorean.time_travel_to "2 weeks ago"

s = Season.create({
                    name: "Season 9",
                    season_number: 9,
                    start_date:    Date.commercial(Date.today.year, Date.today.cweek, 1),
                    end_date:      Date.commercial(Date.today.year, Date.today.cweek, 1) + 6.weeks
                  }, without_protection: true)

teams = Array.new(10) do |i|
  name = SecureRandom.urlsafe_base64(20)
  {
    name: name,
    short_name: name[0...8],
    color: rand(0xffffff),
    d1: true,
    season_id: s.id,
    seed: i + 1
  }
end

Team.create(teams, without_protection: true)

Team.all.each do |team|
  Player.create(Array.new(6){|i|
    {
      username: SecureRandom.urlsafe_base64(8),
      signature: SecureRandom.urlsafe_base64(24),
      title: SecureRandom.urlsafe_base64(16),
      rep: 0,
      role: i == 0 ? "gm" : "player",
      email: SecureRandom.urlsafe_base64(8) + "@example.com",
      password: "password",
      confirmed_at: Time.now,
      team_id: team.id
    }
  }, without_protection: true)
end

season = Season.first
season.schedule!

season.games.each do |game|
  rand(5).+(1).times do
    team = rand(2) == 1 ? :home_team : :away_team
    player = game.send(team).players.order('RANDOM()').first
    game.goals.create([{
      scorer_id: player.id,
      time: rand(300),
      half: rand(3) + 1,
      team_id: player.team.id,
      scored_against: game.send(team == :home_team ? :away_team : :home_team).players.order('RANDOM()').first.id
    }], without_protection: true)
  end

  game.save
end

Delorean.back_to_the_present

Game.where('played_on < ?', Time.now).update_all(finished: true)
Game.where('played_on < ? AND RANDOM() < 0.9', Time.now).update_all(reported: true)
