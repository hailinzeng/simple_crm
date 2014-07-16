class ResetController < ApplicationController

  before_filter :current_user

  def password
    if @current_user.update(user_params)
      flash[:success] = "密码已经更新成功啦."
    else
      flash[:error] = @current_user.errors.full_messages.first
    end
    redirect_to user_reset_index_path
  end

  def index
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

end