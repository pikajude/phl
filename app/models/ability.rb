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
      gm_abilities(player)
    when "agm"
      agm_abilities(player)
    when "player"
      player_abilities(player)
    when "banned"
      cannot :manage, :all
    else
      basic_abilities(player)
    end
  end

  def gm_abilities(player)
    agm_abilities(player)
    can :manage, Team, id: player.team.id
    can :manage, Trade do |tr|
      tr.team == player.team
    end
  end

  def agm_abilities(player)
    player_abilities(player)
    can :manage, Trade do |tr|
      tr.giving_team == player.team
    end
    can :report, Game do |g|
      player.games.include?(g) && !g.reported
    end
  end

  def player_abilities(player)
    basic_abilities(player)
    can :read, Post
    can :attend, Game do |g|
      player.games.include? g
    end
  end

  def basic_abilities(player)
    can :index, Post
  end
end
