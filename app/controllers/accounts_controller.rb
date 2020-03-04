class AccountsController < ApplicationController
  def show
    @user = current_user
  end

  def edit
  end
end
