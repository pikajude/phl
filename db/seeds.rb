Season.create({
                season_number: 9,
                start_date:    Date.commercial(Date.today.year, Date.today.cweek, 1),
                end_date:      Date.commercial(Date.today.year, Date.today.cweek, 1) + 6.weeks
              }, without_protection: true)

s = Season.first

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

Player.create([{
                 username: "otters",
                 signature: "test signature!",
                 title: "PHL administrator",
                 rep: 0,
                 role: "admin",
                 email: "joel@example.com",
                 password: "password",
                 confirmed_at: Time.now
               },
               {
                 username: "IWS",
                 signature: "v gay",
                 title: "title",
                 rep: 0,
                 role: "gm",
                 email: "thing@example.com",
                 password: "password",
                 confirmed_at: Time.now
               },
               {
                 username: "Dummy player",
                 role: "player",
                 email: "foobar@baz.com",
                 password: "bazbazbaz",
                 confirmed_at: Time.now
               }], without_protection: true)

Team.first.players << Player.find_by(username: "otters")
Team.last.players = [Player.find_by(username: "IWS"), Player.find_by(username: "Dummy player")]

ScheduleBox.create([{
                      title: "Schedule"
                    }], without_protection: true)

p = Player.find_by(username: "otters")
p.dashboard_items = [[:schedule, ScheduleBox.first.id]]
p.save

Season.first.schedule!