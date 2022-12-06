require "rails_helper"

RSpec.describe "task display" do
  let(:project) { create(:project, name: "Project Bluebook") }
  let(:user) { create(:user, twitter_handle: "{{twitter_handle}}") }
  let!(:task) { create(:task, project:, user:, completed_at: 1.hour.ago, project_order: 1) }

  before do
    project.roles.create(user:)
    sign_in(user)
  end

  it "shows a gravatar", :vcr do
    visit project_path(project)
    url = "http://pbs.twimg.com/profile_images/40008602/head_shot_bigger.jpg"
    within("#task_1") do
      expect(page).to have_selector(".completed", text: user.email)
      expect(page).to have_selector("img[src='#{url}']")
    end
  end
end
