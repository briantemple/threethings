class TasksController < ApplicationController
  respond_to :json

  def index
    tasks = Task.where({:status => 0, :user => threethings_user})
    tasks.push(*Task.where({:user => threethings_user, :status => 1, :completed_at => Date.today..Date.tomorrow}))

    respond_with tasks
  end

  def show
    respond_with Task.find(params[:id])
  end

  def create
    threethings_user
    task = Task.create(allowed_task_params)
    task.user = threethings_user
    task.save!
    respond_with task
  end

  def update
    respond_with Task.update(params[:id], allowed_task_params)
  end

  def destroy
    respond_with Task.destroy(params[:id])
  end
  
  private
  def allowed_task_params
    params.require(:task).permit(:name, :status, :completed_at)
  end
end
