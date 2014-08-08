class SessionsController < ApplicationController

  def new
    if logined?
      redirect_to profile_index_path
    else
      render layout: "session"
    end
  end

  def create
    @user = User.find_with_login(params[:login], params[:password])
    if @user
      set_current_user(@user)
      redirect_back_or_default profile_index_path
    else
      flash[:error] = "亲，帐号或密码错误."
      redirect_to new_session_path
    end
  end

  def destroy
    if logined?
      logout
      flash[:success] = "注销成功"
    end
    redirect_back_or_default new_session_path
  end

end