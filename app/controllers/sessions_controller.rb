class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: session_params[:email])

    # パスワードを認証できればsessionにIDを格納する
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to :root, notice: 'ログインしました'
    else
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to :root, notice: 'ログアウトしました'
  end

  private
  def session_params
    params.require(:session).permit(:email, :password)
  end
end
