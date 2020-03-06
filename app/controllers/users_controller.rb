class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      SignupMailer.creation_mail(@user).deliver_now
      redirect_to :root, notice: "#{@user.name}さんを登録しました"
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

