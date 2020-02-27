class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :done]
  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page])
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

  def done
    if @task.done
      @task.done = false
    else
      @task.done = true
    end
    @task.save
  end

  private
  
  def task_params
    params.require(:task).permit(:name, :description, :image, :place, :done, :deadline)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
