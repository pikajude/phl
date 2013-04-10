require 'test_helper'

class MatchReporterTest < ActionDispatch::IntegrationTest
  include AuthIntegrationHelper

  setup do
    @gm = Player.where(role: "gm").first
    @player = Player.where(role: "player").first
    @game = @gm.team.games.first
    @other_gm = Player.where("role = 'gm' AND team_id NOT IN (?)", [@game.home_team.id, @game.away_team.id]).first
  end

  teardown do
    logout
  end
    
  context "role filtering" do
    should "reject unauthorized users" do
      get new_report_path(@game)
      assert_redirected_to '/'
    end

    should "reject players" do
      login_as @player
      get new_report_path(@game)
      assert_redirected_to '/'
    end

    should "reject GMs not on the team" do
      login_as @other_gm
      get new_report_path(@game)
      assert_redirected_to '/'
    end

    should "allow GMs that are on the team" do
      login_as @gm
      visit new_report_path(@game)
      # assert page.status_code == 200
    end
  end
  
  context "allowed GMs" do
    setup do
      login_as @gm
      visit new_report_path(@game)
    end

    should "be able to manage goals" do
      make_a_goal
      assert page.has_selector? ".goals .home"
      find(".delete-goal").click
      assert page.has_no_selector? ".goals div"
    end
  end

  private
  def make_a_goal
    find(".buttons .home-team").click_button "Goal+"
  end
end
