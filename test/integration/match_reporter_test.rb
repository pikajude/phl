require File.expand_path('../test_helper.rb', File.dirname(__FILE__))

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
      assert_equal page.status_code, 200
    end
  end
  
  context "allowed GMs" do
    setup do
      login_as @gm
      visit new_report_path(@game)
    end

    teardown do
      find(".delete-goal").click
      assert page.has_no_selector? ".goals div"
    end

    should "be able to create or delete goals" do
      make_a_goal
      assert page.has_selector? ".goals .home"
    end

    should "be able to input a valid time" do
      make_a_goal
      within(".goals") do
        find(".goal-time").set("1:00")
      end
      page.execute_script("$('.goals .goal-time').blur()")
      visit(current_path)
      assert_equal find(".goals .goal-time").value, "1:00"
    end

    should "not be able to input an invalid time" do
      make_a_goal
      within(".goals") do
        find(".goal-time").set("0:60")
      end
      page.execute_script("$('.goals .goal-time').blur()")
      assert find("ul.errors li").has_content? "Time must be a valid number of seconds."
      visit(current_path)
      assert_not_equal find(".goals .goal-time").value, "0:60"
    end
    
    should "be able to select a scorer" do
      make_a_goal
      page.find ".scorer"
      var = page.evaluate_script("$('.scorer')[0].outerHTML")
      options = Nokogiri::XML(var).children[0].children.map(&:text).reject{|x|x=="\n"}
      within(".scorer") do
        select options[1]
      end
      visit(current_path)
      assert_equal find(:xpath, "//select[@class = 'scorer']/option[@selected = 'selected']").text, options[1] 
    end

    should "not be able to pick the scorer as the first assist" do
      make_a_goal
      page.find ".scorer"
      var = page.evaluate_script("$('.scorer')[0].outerHTML")
      options = Nokogiri::XML(var).children[0].children.map(&:text).reject{|x|x=="\n"}
      within(".scorer") do
        select options[1]
      end
      assert page.has_no_xpath?("//select[@class = 'first-assist']/option[text() = '#{options[1]}']")
    end
  end

  private
  def make_a_goal
    find(".buttons .home-team").click_button "Goal+"
  end
end
