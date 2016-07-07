class ProjectsController < ApplicationController
  before_action :set_project, only: [:edit, :update, :destroy]
  layout 'modal', only: [:new, :edit]

  def index
    @projects = current_user.projects
  end

  def edit
  end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      render json: { success: "Project was successfully created", id: @project.id, name: @project.name }, status: 201
    else
      render json: { errors: @project.errors }, status: 422
    end
  end

  def update
    if @project.update(project_params)
      render json: { success: "Project was successfully updated." , id: @project.id, name: @project.name }, status: 201
    else
      render json: { errors: @project.errors }, status: 422
    end
  end

  def new
    @project = Project.new
  end

  def destroy
    if @project.destroy
      render json: { success: "Project was successfully destroyed." }, status: 200
    else
      render json: { error: @project.errors.full_messages.to_sentence }, status: 422
    end
  end

  private
  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :user_id)
  end
end
