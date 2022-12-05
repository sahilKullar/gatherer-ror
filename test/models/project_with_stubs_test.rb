require "test_helper"

class ProjectWithStubsTest < ActiveSupport::TestCase
  test "let's stub an object" do
    project = Project.new(name: "Project Greenlight")
    project.stubs(:name)
    assert_nil(project.name)
  end

  test "let's stub a class" do
    Project.stubs(:find).returns(Project.new(name: "Project Greenlight"))
    project = Project.find(1)
    assert_equal("Project Greenlight", project.name)
  end

  test "stub with multiple returns" do
    stubby = Project.new
    stubby.stubs(:user_count).returns(1, 2)
    # stubby.stubs(:user_count).returns(1).then.returns(2)
    assert_equal(1, stubby.user_count)
    assert_equal(2, stubby.user_count)
    assert_equal(2, stubby.user_count)
  end
end
# Project.any_instance.stubs(:save).returns(false)
# stubby.stubs(:user_count).raises(Exception, "oops")