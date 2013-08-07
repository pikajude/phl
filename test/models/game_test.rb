require 'test_helper'

class GameTest < MiniTest::Unit::TestCase
  def setup
    @season = create(:season)
  end

  def teardown
    DatabaseCleaner.clean
  end

  context "reports" do
    should "complain about a missing match report" do
      @game = create(:game, played_on: 3.hours.ago)

      @game.missing_report?.should == true
    end
  end

  context "stat calc" do
    should "calculate stats correctly" do
      @sub = create(:substitution, off_time: 600)
      @player = @sub.player
      3.times do
        @goal = create(:goal, game_id: @sub.game_id, scorer_id: @player.id, team_id: @sub.team_id, time: 0, half: 1)
      end
      2.times do
        @goal = create(:goal, game_id: @sub.game_id, scorer_id: @sub.team.players.last.id, first_assist_id: @player.id, team_id: @sub.team_id, time: 0, half: 1)
      end
      @goal.game.__send__ :update_stats

      @player.reload.points.should == 5
      @player.goals.should == 3
      @player.assists.should == 2
      @player.ppg.should == 5
    end

    should "calculate gaa properly" do
      @sub = create(:substitution, off_time: 600)
      @player = @sub.player
      3.times do
        @goal = create(:goal, game_id: @sub.game_id, scorer_id: @sub.game.away_team.players.first.id, scored_against: @player.id, team_id: @sub.team_id, time: 0, half: 1)
      end
      @goal.game.__send__ :update_stats

      @player.reload.gaa.should == 3
    end

    should "disregard previous seasons" do
      @old_season = create(:season,
                           start_date: Date.commercial(Date.today.year - 1, Date.today.cweek, 1) - 2.weeks,
                           end_date: Date.commercial(Date.today.year - 1, Date.today.cweek, 1) + 4.weeks)
      @sub1 = create(:substitution, off_time: 600, season_id: @old_season.id)
      @player = @sub1.player
      @sub2 = create(:substitution, off_time: 600, player_id: @player.id)
      Game.last.__send__ :update_stats

      @player.reload.seconds_played.should == 600
    end
  end
end
