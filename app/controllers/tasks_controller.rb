class TasksController < ApplicationController
  layout 'modal', only: [:new, :edit]

  def new
    @project = find_project
    @task = @project.tasks.build
  end

  def create
    project = find_project
    task = project.tasks.build(task_params)
    if task.save
      render json: { success: "Task was successfully created",
                     task: task}, status: 201
    else
      render json: { errors: task.errors }, status: 422
    end
  end

  def edit
    @project = find_project
    @task = @project.tasks.find(params[:id])
  end

  def update
    task = find_task
    if task.update(task_params)
      render json: { success: "Task was successfully updated.",
                     task: task }, status: 201
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
    project = find_project
    params[:task].each_with_index do |id, index|
      project.tasks.find(id).update_column :prioritize, (index + 1)
    end
    render nothing: true
  end

  private
  def find_task
    project = find_project
    project.tasks.find(params[:id])
  end

  def find_project
    Project.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:project_id, :name, :deadline, :mark_as_done, :prioritize)
  end
end
