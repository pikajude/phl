Delorean.time_travel_to "2 weeks ago"

s = Season.create({
                    name: "Season 9",
                    season_number: 9,
                    start_date:    Date.commercial(Date.today.year, Date.today.cweek, 1),
                    end_date:      Date.commercial(Date.today.year, Date.today.cweek, 1) + 6.weeks
                  }, without_protection: true)

i = 0

teams = [
  {
    name: "Animal House",
    short_name: "Animals",
    color: 0xf0ff0f
  },

  {
    name: "Fresno Forest Fires",
    short_name: "FFF",
    color: 0x9f00ff
  },

  {
    name: "Honolulu Frog Dogs",
    short_name: "HFD",
    color: 0x008000
  },
  
  {
    name: "Pacific Killa Beez",
    short_name: "Beez",
    color: 0xff6600
  },

  {
    name: "Prestige Worldwide",
    short_name: "PWW",
    color: 0x666666
  },

  {
    name: "Riverside Royals",
    short_name: "Royals",
    color: 0xbf049a
  },

  {
    name: "Sexy Sharks",
    short_name: "Sharks",
    color: 0x000000
  },

  {
    name: "Style Squad",
    short_name: "SS",
    color: 0x99cc00
  },

  {
    name: "Swamp Donkis",
    short_name: "Donkis",
    color: 0x616d7e
  },

  {
    name: "Talladega Nights",
    short_name: "Nights",
    color: 0x000052
  }
].map do |v|
  name = SecureRandom.urlsafe_base64(20)
  {
    d1: true,
    season_id: s.id,
    seed: i + 1
  }.merge(v).tap { i += 1 }
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

Delorean.back_to_1985
