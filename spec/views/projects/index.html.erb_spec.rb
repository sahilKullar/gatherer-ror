require "rails_helper"
describe "projects/index" do
  let(:on_schedule) do
    Project.create!(due_date: 1.year.from_now, name: "On Schedule")
  end

  let(:behind_schedule) do
    Project.create!(due_date: 1.day.from_now, name: "Behind Schedule")
  end

  let(:completed_task) do
    Task.create!(completed_at: 1.day.ago, size: 1, project: on_schedule)
  end

  let(:incomplete_task) do
    Task.create!(size: 1, project: behind_schedule)
  end

  it "renders the index page with correct dom elements" do
    on_schedule.tasks << completed_task
    behind_schedule.tasks << incomplete_task

    @projects = [on_schedule, behind_schedule]
    render
    # render template: "projects/index"
    within("#project_#{on_schedule.id}") do
      expect(rendered).to have_selector(".on_Schedule")
    end

    expect(rendered).to have_selector("#project_#{on_schedule.id} .on_schedule")
    expect(rendered).to have_selector("#project_#{behind_schedule.id} .behind_schedule")
  end
end
