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

puts "Login: #{Player.first.username}
Password: password"

IO.popen("pbcopy", "w") do |pipe|
  pipe.write Player.first.username
end
