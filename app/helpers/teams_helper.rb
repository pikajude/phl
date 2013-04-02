module TeamsHelper
  def colored_team_name team, short: true
    link_to team.send(short ? :short_name : :name), team_page_path(team.slug), class: "colored_name #{team.bright ? "light" : "dark"}", style: "color: #{team.hex_color}"
  end
end
