module PlayersHelper
  def colored_player_name player
    klass = case player.brightness
            when 0..0.3
              "dark"
            when 0.3..0.7
              "medium"
            else
              "bright"
            end
    link_to player.username, player_profile_path(player), class: "colored_name #{klass}", style: "color: #{player.hex_color}"
  end

  def attendance_button player, game
    attending = player.attending? game
    content_tag :span, class: "game-attendance #{attending ? "yes" : "no"}", id: "game-attendance-#{game.id}" do
      content_tag(:i, "", class: "icon-spin icon-asterisk hidden") +
      link_to((attending ? "coming" : "not coming"), attend_game_path(game), class: "button #{attending ? "green" : "red"}", remote: true)
    end
  end
end
