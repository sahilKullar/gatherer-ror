require "test_helper"

class ProjectsHelperTest < ActionView::TestCase
  test "project name with status info" do
    project = Project.new(name: "Project Runway")
    project.stubs(:on_schedule?).returns(true)
    actual = name_with_status(project)
    expected = "<span class='on_schedule'>Project Runway</span>"
    assert_dom_equal(expected, actual)
  end

  test "project name with status info behind schedule" do
    project = Project.new(name: "Project Runway")
    project.stubs(:on_schedule?).returns(false)
    actual = name_with_status(project)
    expected = "<span class='behind_schedule'>Project Runway</span>"
    assert_dom_equal(expected, actual)
  end

  test "project name using assert_select" do
    project = Project.new(name: "Project Runway")
    project.stubs(:on_schedule?).returns(false)
    assert_select_string(name_with_status(project), "span.behind_schedule")
  end
end
