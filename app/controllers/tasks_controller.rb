class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :destroy]
  layout 'modal', only: [:new, :edit]

  def new
    @project = Project.find(params[:project_id])
    @task = @project.tasks.build
  end

  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.build(task_params)
    if @task.save
      render json: { success: "Task was successfully created",
                     id: @task.id,
                     project_id: @project.id,
                     name: @task.name,
                     deadline: @task.deadline,
                     mark_as_done: @task.mark_as_done }, status: 201
    else
      render json: { errors: @task.errors }, status: 422
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      render json: { success: "Task was successfully updated.",
                     id: @task.id,
                     name: @task.name,
                     mark_as_done: @task.mark_as_done }, status: 201
    else
      render json: { errors: @task.errors }, status: 422
    end
  end

  def destroy
    if @task.destroy
      render json: { success: "Task was successfully destroyed." }, status: 200
    else
      render json: { error: @task.errors.full_messages.to_sentence }, status: 422
    end
  end

  def sort
    project = Project.find(params[:project_id])
    params[:task].each_with_index do |id, index|
      project.tasks.find(id).update_column :prioritize, (index + 1)
    end
    render nothing: true
  end

  private
  def set_task
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:project_id, :name, :deadline, :mark_as_done, :prioritize)
  end
end
