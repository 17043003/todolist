class AccountsController < ApplicationController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.assign_attributes(account_params)
    if @user.save
      redirect_to :account, notice: 'アカウント情報を編集しました'
    else
      render 'edit'
    end
  end

  private
  def account_params
    params.require(:account).permit(:name, :email)
  end
end
