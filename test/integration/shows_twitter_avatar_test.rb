require "test_helper"

class TaskShowsTwitterAvatar < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    @user = FactoryBot.create(:user, twitter_handle: "{{twitter_handle}}")
    @user.update(twitter_handle: "{{twitter_handle}}")
    @project = FactoryBot.create(:project, name: "Project Bluebook")
    @project.roles.create(user: @user)
    @task = FactoryBot.create(:task, project: @project)
    @task.update(user_id: @user.id, project_order: 1, completed_at: 1.hour.ago)
    login_as @user
  end

  test "I see a gravatar" do
    VCR.use_cassette("loading_twitter") do
      visit project_path(@project)
      url = "http://pbs.twimg.com/profile_images/1371552537153781764/77cdD1px_bigger.jpg"
      within("#task_1") do
        assert_selector(".completed", text: @user.email)
        assert_selector("img[src='#{url}']")
      end
    end
  end
end
