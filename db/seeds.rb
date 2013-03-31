Team.create([{
               name: "Talladega Nights",
               short_name: "Nights",
               color: '#ffcc00',
               d1: true
             },
             {
               name: "Animal House",
               short_name: "Animals",
               color: "#032fa3",
               d1: true
             }], without_protection: true)


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

Team.find_by(name: "Talladega Nights").players << Player.find_by(username: "otters")
Team.find_by(name: "Animal House").players = [Player.find_by(username: "IWS"), Player.find_by(username: "Dummy player")]
