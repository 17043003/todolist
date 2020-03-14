require 'json'
require 'net/https'
require "uri"

class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :done]
  def index
    @selected_tag = nil
    if params[:tag].present?
      tag_included_tasks = current_user.tasks.where(tag_id: params[:tag])
      @selected_tag = params[:tag]
    else
      tag_included_tasks = current_user.tasks
    end

    @q = tag_included_tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page])

    if current_user.tags.present?
      @user_tags = current_user.tags.map { |tag| [tag.name, tag.id] }
      @user_tags.unshift(["全て", nil]) # タスクを全て表示するオプション
    else
      @user_tags = ["全て", nil] # タスクを全て表示するオプション
    end
  end

  def show
    # google geocode apiで場所の緯度経度を取得
    geo_endpoint = "https://maps.googleapis.com/maps/api/geocode/json?address=#{@task.place}&key=#{ENV['KEY']}"

    uri = URI.parse(URI.encode(geo_endpoint))

    response = Net::HTTP.get_response(uri)
    response_body = JSON.parse(response.read_body)

    lat = response_body['results'][0]['geometry']['location']['lat']
    lng = response_body['results'][0]['geometry']['location']['lng']


    # heartrails apiを利用し、最寄り駅の緯度経度を取得
    heart_endpoint = "http://express.heartrails.com/api/json?method=getStations&x=#{lng}&y=#{lat}"

    uri = URI(heart_endpoint)

    response = Net::HTTP.get_response(uri)
    response_body = JSON.parse(response.read_body)
    @station = response_body['response']['station'][0]
    @station_lat = @station['y']
    @station_lng = @station['x']
  end

  def new
    @task = Task.new

    # tagを取得
    if current_user.tags.present?
      @user_tags = current_user.tags.map { |tag| [tag.name, tag.id] }
      @user_tags.unshift(["未設定", nil]) # タスクを全て表示するオプション
    else
      @user_tags = ["未設定", nil] # タスクを全て表示するオプション
    end
  end

  def edit
    if current_user.tags.present?
      @user_tags = current_user.tags.map { |tag| [tag.name, tag.id] }
      @user_tags.unshift(["未設定", nil]) # タスクを全て表示するオプション
    else
      @user_tags = ["未設定", nil] # タスクを全て表示するオプション
    end
  end

  def create
    # userに関連したtaskオブジェクトを代入
    @task = current_user.tasks.new(task_params)

    # 既存のタグが入力されていればオブジェクトを代入する
    existed_tag = current_user.tags.find_by(name: tag_params[:new_tag_name])

    # フォームに入力されたタグが存在しないとき、タグを保存する
    if !existed_tag
      new_tag = current_user.tags.new(name: tag_params[:new_tag_name])
      new_tag.save
      @task.tag_id = new_tag.id
    else
      @task.tag_id = existed_tag.id
    end

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
    params.require(:task).permit(:name, :description, :tag_id, :image, :place, :done, :deadline)
  end

  def tag_params
    params.require(:task).permit(:new_tag_name)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
