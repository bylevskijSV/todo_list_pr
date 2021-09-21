class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy complete]
  before_action :check_user_tasks, only: %i[show edit update destroy]
  before_action :not_edit_assigned_task, only: %i[update edit complete]

  def index
    @tasks = current_user.tasks.where.not(status: Task::DONE).order(updated_at: :desc)

    @completed_tasks = current_user.tasks.where(status: Task::DONE).order(updated_at: :desc)

    @assigned_tasks = Task.where(assigned_to: current_user).includes(:assigned_to)
  end

  def new
    @task = Task.new

    @users_for_select = emails_and_users_id
  end

  def show; end

  def create
    @task = assigned_task? ? Task.create(assigned_task_params) : current_user.tasks.create(task_params)

    if @task.errors.empty?
      redirect_to tasks_path
    else
      @users_for_select = emails_and_users_id
      render :edit
    end
  end

  def edit
    @users_for_select = emails_and_users_id
  end

  def update
    updated_task = assigned_task? ? assigned_task_params : task_params

    if @task.update updated_task
      flash[:notice] = 'Task was updated successfully'
      redirect_to tasks_path
    else
      @users_for_select = emails_and_users_id
      render 'edit'
    end
  end

  def destroy
    @task.destroy
    flash[:alert] = 'Task was deleted successfully'
    redirect_to tasks_path
  end

  def complete
    @task.complete!

    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end

  def assigned_task_params
    user_id = params[:task][:assigned_to]
    assigned_to = current_user
    task_params.merge(user_id: user_id, assigned_to: assigned_to)
  end

  def assigned_task?
    params[:task][:assigned_task].to_i == 1
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def check_user_tasks
    return if current_user == @task.user || check_assigned_tasks?

    flash[:alert] = 'You can only edit, view, delete your own task'
    redirect_to tasks_path
  end

  def not_edit_assigned_task
    return unless check_assigned_tasks?

    flash[:alert] = 'You can view and delete your assigned tasks'
    redirect_to tasks_path
  end

  def check_assigned_tasks?
    current_user.id == @task.assigned_to_id
  end

  def emails_and_users_id
    User.where.not(email: current_user.email).pluck(:email, :id)
  end
end
