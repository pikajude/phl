require 'test_helper'

class GameTest < MiniTest::Unit::TestCase
  context "reports" do
    should "complain about a missing match report" do
      @game = create(:game, :played_on => 3.hours.ago)

      @game.missing_report?.should == true
    end
  end

  context "stat calc" do
    should "calculate stats correctly" do
      @sub = create(:substitution, :off_time => 600)
      @player = @sub.player
      3.times do
        @goal = create(:goal, :game_id => @sub.game_id, :scorer_id => @player.id, :team_id => @sub.team_id, :time => 0, :half => 1)
      end
      2.times do
        @goal = create(:goal, :game_id => @sub.game_id, :scorer_id => @sub.team.players.last.id, :first_assist_id => @player.id, :team_id => @sub.team_id, :time => 0, :half => 1)
      end
      @goal.game.__send__ :update_stats

      @player.reload.points.should == 5
      @player.goals.should == 3
      @player.assists.should == 2
      @player.ppg.should == 5
    end

    should "calculate gaa properly" do
      @sub = create(:substitution, :off_time => 600)
      @player = @sub.player
      3.times do
        @goal = create(:goal, :game_id => @sub.game_id, :scorer_id => @sub.game.away_team.players.first.id, :scored_against => @player.id, :team_id => @sub.team_id, :time => 0, :half => 1)
      end
      @goal.game.__send__ :update_stats

      assert_equal 3, @player.reload.gaa
    end
  end
end
