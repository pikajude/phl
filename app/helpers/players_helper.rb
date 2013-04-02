module PlayersHelper
  def colored_player_name player
    link_to player.username, player_profile_path(player), class: "colored_name #{player.bright ? "light" : "dark"}", style: "color: #{player.hex_color}"
  end

  def attendance_button player, game
    attending = player.attending? game
    link_to (attending ? "coming" : "not coming"), attend_game_path(game), class: "button #{attending ? "green" : "red"}", remote: true
  end
end
