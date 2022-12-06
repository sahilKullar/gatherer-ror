class CreatesProject
  attr_accessor :name, :project, :task_string, :users

  def initialize(name: "", task_string: "", users: [])
    @name = name
    @task_string = task_string || ""
    @success = true
    @users = users
  end

  def success?
    @success
  end

  def build
    self.project = Project.new(name:)
    project.tasks = convert_string_to_tasks
    project.users = users
    project
  end

  def create
    build
    result = project.save
    @success = result
  end

  def convert_string_to_tasks
    task_string.split("\n").map.with_index do |one_task, index|
      title, size_string = one_task.split(":")
      Task.new(title:, size: size_as_integer(size_string), project_order: index + 1)
    end
  end

  def size_as_integer(size_string)
    return 1 if size_string.blank?

    [size_string.to_i, 1].max
  end
end
