require "rails_helper"

RSpec.describe User do
  RSpec::Matchers.define :be_able_to_see do |*projects|
    match do |user|
      expect(user.visible_projects).to eq(projects)
      projects.all? { |p| expect(user).to be_can_view(p) }
      (all_projects - projects).all? do |p|
        expect(user).not_to be_can_view(p)
      end
    end
  end

  describe "visibility" do
    let(:user) { create(:user, email: "user@example.com", password: "password") }
    let(:project_1) { create(:project, name: "Project 1") }
    let(:project_2) { create(:project, name: "Project 2") }
    let(:all_projects) { [project_1, project_2] }

    it "a user can see their projects" do
      user.projects << project_1
      expect(user).to be_able_to_see(project_1)
    end

    it "an admin can see all projects" do
      user.admin = true
      expect(user).to be_able_to_see(project_1, project_2)
    end

    it "a user can see public projects" do
      user.projects << project_1
      project_2.update(public: true)
      expect(user).to be_able_to_see(project_1, project_2)
    end

    it "no dupes in project list" do
      user.projects << project_1
      project_1.update(public: true)
      expect(user).to be_able_to_see(project_1)
    end
  end

  # let(:project) { create(:project) }
  # let(:user) { create(:user) }
  #
  # it "cannot view a project it is not a part of" do
  #   expect(user).not_to be_can_view(project)
  # end
  #
  # it "can view a project it is a part of" do
  #   Role.create(user:, project:)
  #   expect(user).to be_can_view(project)
  # end
  #
  # describe "public roles" do
  #   it "allows an admin to view a project" do
  #     user.admin = true
  #     expect(user).to be_can_view(project)
  #   end
  #
  #   it "allows an user to view a public project" do
  #     project.public = true
  #     expect(user).to be_can_view(project)
  #   end
  # end
  #
  # describe "visible projects" do
  #   let!(:project_1) { create(:project, name: "Project 1") }
  #   let!(:project_2) { create(:project, name: "Project 2") }
  #
  #   it "allows a user to see their projects" do
  #     user.projects << project_1
  #     expect(user.visible_projects).to eq([project_1])
  #   end
  #
  #   it "allows an admin to see all projects" do
  #     user.admin = true
  #     expect(user.visible_projects).to match_array(Project.all)
  #   end
  #
  #   it "allows a user to see public projects" do
  #     user.projects << project_1
  #     project_2.update(public: true)
  #     expect(user.visible_projects).to match_array([project_1, project_2])
  #   end
  #
  #   it "has no duplicates in project list" do
  #     user.projects << project_1
  #     project_1.update(public: true)
  #     expect(user.visible_projects).to match_array([project_1])
  #   end
  # end
end
