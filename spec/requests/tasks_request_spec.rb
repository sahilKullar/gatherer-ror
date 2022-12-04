# frozen_string_literal: true

require "rails_helper"

RSpec.describe "task requests" do
  before do
    ActionMailer::Base.deliveries.clear
  end

  let(:project) { create(:project, name: "Project Bluebook") }
  let(:task) {  create(:task, project:, title: "Learn how to test mailers", size: 3) }

  it "does not send an email if a task is not completed" do
    patch(task_path(id: task.id), params: { task: { completed: false } })
    expect(ActionMailer::Base.deliveries.size).to eq(0)
  end

  it "sends email when task is completed" do
    patch(task_path(id: task.id), params: { task: { completed: true } })
    expect(ActionMailer::Base.deliveries.size).to eq(1)
    email = ActionMailer::Base.deliveries.first
    expect(email.subject).to eq("A task has been completed")
    expect(email.to).to eq(["monitor@tasks.com"])
    expect(email.body.to_s).to match(/Learn how to test mailers/)
  end
end
