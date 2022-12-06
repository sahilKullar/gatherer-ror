require "rails_helper"

RSpec.describe ProjectsController do
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  describe "create" do
    it "calls the workflow with parameters" do
      workflow = instance_spy(CreatesProject, success?: true)
      allow(CreatesProject).to receive(:new).and_return(workflow)
      post :create, params: { project: { name: "Runway", tasks: "start something:2" } }
      expect(CreatesProject).to have_received(:new).with(name: "Runway", task_string: "start something:2",
                                                         users: [user])
    end
  end
end
