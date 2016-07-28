class TasksController < ApplicationController
  layout 'modal', only: [:new, :edit]
  before_action :find_project, only: [:new, :create, :edit]

  def new
    @task = @project.tasks.build
  end

  def create
    task = @project.tasks.build(task_params)
    if task.save
      render json: { success: "Task was successfully created",
                     task: task}, status: 201
    else
      render json: { errors: task.errors }, status: 422
    end
  end

  def edit
    @task = @project.tasks.find(params[:id])
  end

  def update
    task = find_task
    if task.update(task_params)
      if params[:only_message]
        render json: { success: "Field 'mark as done' was successfully updated." }, status: 201
      else
        render json: { success: "Task was successfully updated.",
                     task: task }, status: 201
      end
    else
      render json: { errors: task.errors }, status: 422
    end
  end

  def destroy
    task = find_task
    if task.destroy
      render json: { success: "Task was successfully destroyed." }, status: 200
    else
      render json: { error: task.errors.full_messages.to_sentence }, status: 422
    end
  end

  def sort
    find_project
    params[:task].each_with_index do |id, index|
      @project.tasks.find(id).update_column :prioritize, (index + 1)
    end
    render nothing: true
  end

  private
  def find_task
    find_project
    @project.tasks.find(params[:id])
  end

  def find_project
    @project = Project.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:project_id, :name, :deadline, :mark_as_done, :prioritize)
  end
end
