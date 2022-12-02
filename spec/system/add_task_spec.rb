# frozen_string_literal: true

require "rails_helper"

RSpec.describe "adding a new task" do
  let!(:project) { create(:project, name: "Project Bluebook") }
  # let!(:task_1) { create(:task, project:, title: "Search Sky", size: 1) }
  # let!(:task_2) { create(:task, project:, title: "Use Telescope", size: 1) }
  let!(:task_1) { create(:task, project:, title: "Search Sky", size: 1, project_order: 1) }
  let!(:task_2) { create(:task, project:, title: "Use Telescope", size: 1, project_order: 2) }

  it "can add and reorder a task" do
    visit(project_path(project))
    fill_in("Task", with: "Find UFOs")
    select("2", from: "Size")
    click_on("Add Task")
    expect(page).to have_current_path(project_path(project), ignore_query: true)

    within("#task_3") do
      expect(page).to have_selector(".name", text: "Find UFOs")
      expect(page).to have_selector(".size", text: "2")
      expect(page).not_to have_selector("a", text: "Down")
      click_on("Up")
    end

    expect(page).to have_current_path(project_path(project), ignore_query: true)

    within("#task_2") do
      expect(page).to have_selector(".name", text: "Find UFOs")
    end
  end
end
