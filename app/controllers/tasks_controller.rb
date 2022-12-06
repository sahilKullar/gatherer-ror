class TasksController < ApplicationController
  before_action :load_task, only: %i[up down]

  def create
    @project = Project.find(params[:task][:project_id])
    unless current_user.can_view?(@project)
      redirect_to new_user_session_path
      return
    end
    @project.tasks.create(task_params.merge(project_order: @project.next_task_order))
    redirect_to(@project)
  end

  def update
    @task = Task.find(params[:id])
    completed = params[:task][:completed] == "true" && !@task.complete?
    params[:task][:completed_at] = Time.current if completed
    if @task.update(task_params)
      TaskMailer.task_completed_email(@task).deliver if completed
      redirect_to @task, notice: "project was successfully updated"
    else
      render action :edit
    end
  end

  def up
    @task.move_up
    redirect_to(@task.project)
  end

  def down
    @task.move_down
    redirect_to(@task.project)
  end

  private

  def load_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:project_id, :title, :size)
  end
end
