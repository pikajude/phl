class Ability
  include CanCan::Ability

  def initialize(player)
    player ||= Player.new
    case player.role
    when "admin"
      can :manage, :all

    when "moderator"
      can :read, :all

    when "gm"
      can :manage, Team, id: player.team.id
      can :manage, Trade do |tr|
        tr.team == player.team
      end
      can :report, Game do |g|
        player.games.include?(g) && !g.reported
      end
      can :manage, Goal do |g|
        player.games.include?(g.game)
      end
      can :read, Post

    when "agm"
      can :manage, Trade do |tr|
        tr.giving_team == player.team
      end
      can :report, Game do |g|
        player.games.include?(g) && !g.reported
      end
      can :attend, Game do |g|
        player.games.include? g
      end
      can :manage, Team
      can :read, Post

    when "player"
      can :read, Post
      can :attend, Game do |g|
        player.games.include? g
      end

    when "banned"
      cannot :manage, :all

    else
      can :index, Post
    end
  end
end
