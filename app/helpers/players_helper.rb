module PlayersHelper
  def colored_name player
    content_tag(:span, player.username, class: "colored_name", style: "color: #{player.hex_color}")
  end
end
