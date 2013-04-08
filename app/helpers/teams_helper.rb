module TeamsHelper
  def colored_team_name team, short: true, **opts
    klass = case team.brightness
            when 0..0.3
              "dark"
            when 0.3..0.7
              "medium"
            else
              "light"
            end
    link_to team.send(short ? :short_name : :name), team_page_path(team.slug), {
      class: "colored_name #{klass} #{opts[:class]}",
      style: "color: #{team.hex_color}"
    }
  end
end
