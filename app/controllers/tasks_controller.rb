class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def index
    @tasks = current_user.tasks.recent_created
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    # userに関連したtaskオブジェクトを代入
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: "タスク「#{@task.name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_path, notice: "タスク「#{@task.name}」を削除しました。"
    end
  end

  private
  
  def task_params
    params.require(:task).permit(:name, :description, :place)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
