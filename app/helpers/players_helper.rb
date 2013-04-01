module PlayersHelper
  def colored_name player, name
    content_tag(:span, name, class: "colored_name #{player.bright ? "light" : "dark"}", style: "color: #{player.hex_color}")
  end

  def attendance_button player, game
    attending = player.attending? game
    link_to (attending ? "coming" : "not coming"), attend_game_path(game), class: "button #{attending ? "green" : "red"}", remote: true
  end
end
