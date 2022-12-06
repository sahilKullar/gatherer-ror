class ProjectsController < ApplicationController
  def index
    @projects = current_user.visible_projects
  end

  def show
    @project = Project.find(params[:id])
    unless current_user.can_view?(@project)
      redirect_to new_user_session_path
      return
    end
    respond_to do |format|
      format.html {}
      format.js { render json: @project.as_json(root: true, include: :tasks) }
    end
  end

  def new
    @project = Project.new
  end

  def create
    @workflow = CreatesProject.new(name: params[:project][:name], task_string: params[:project][:tasks],
                                   users: [current_user])
    @workflow.create
    if @workflow.success?
      redirect_to projects_path
    else
      @project = @workflow.project
      render :new
    end
  end
end
