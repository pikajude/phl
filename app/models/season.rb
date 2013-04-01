class Season < ActiveRecord::Base
  has_many :drafts
  has_many :games
  has_many :teams

  validates_presence_of :start_date
  validates_presence_of :end_date

  class << self
    def current
      Season.where('start_date <= ? AND end_date >= ?', Date.today, Date.today).first
    end

    def current_week
      Season.current.current_week rescue nil
    end

    def current_day
      Date.today.cwday
    end

    def next_games
      cur = Season.current
      g = if Season.current_day > 3
        cur.games.where(week: cur.current_week + 1, day: 1)
      else
        cur.games.where(week: cur.current_week, day: Season.current_day)
      end.first
      if g.nil?
        Game.none
      else
        cur.games.where('played_on >= ?', g.played_on)
      end
    end

    def previous_games
      cur = Season.current
      g = if Season.current_day == 1
        cur.games.where(week: cur.current_week - 1, day: 3)
      else
        cur.games.where(week: cur.current_week, day: [Season.current_day, 3].min)
      end.first
      if g.nil?
        Game.none
      else
        cur.games.where('played_on <= ?', g.played_on)
      end
    end

    def next_games_for team_id
      Season.next_games.where('home_team_id = ? OR away_team_id = ?', team_id, team_id)
    end

    def previous_games_for team_id
      Season.previous_games.where('home_team_id = ? OR away_team_id = ?', team_id, team_id)
    end
  end

  def current_week
    Date.today.cweek - self.start_date.to_date.cweek + 1
  end

  def schedule!
    #
    # 1  2  3  4  5
    # 10 9  8  7  6
    #
    # 1  10 2  3  4
    # 9  8  7  6  5
    #
    # 1  9  10 2  3
    # 8  7  6  5  4
    #
    # etc.

    season_start = self.start_date
    ids = self.teams.map(&:id)
    top, bottom = *ids.each_slice(ids.count / 2).to_a
    first = top.first
    day = 1
    week = 1
    2.times do |j|
      (ids.count - 1).times do |i|
        orders = (1..5).to_a
        top.zip(bottom).each do |home,away|
          order = orders.shuffle!.pop
          opts = {
            season_id: self.id,
            order:     order,
            week:      week,
            day:       day,
            played_on: season_start + (week - 1).weeks + (day - 1).days + (order * 15 + 1185).minutes
          }
          if i.odd? && home == first
            self.games.create!(opts.merge({ home_team_id: away, away_team_id: home }), without_protection: true)
          else
            self.games.create!(opts.merge({ home_team_id: home, away_team_id: away }), without_protection: true)
          end
        end
        fixed = top.shift
        top.unshift(bottom.shift)
        top.unshift(fixed)
        bottom << top.pop
        day += 1
        if day == 4
          week += 1
          day = 1
        end
      end
    end
  end
end
