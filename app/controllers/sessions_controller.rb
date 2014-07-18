class SessionsController < ApplicationController

  def new
    if logined?
      redirect_to profile_users_path
    else
      render layout: "session"
    end
  end

  def create
    @user = User.find_with_login(params[:login], params[:password])
    if @user
      set_current_user(@user)
      flash[:success] = "登录成功啦,激情的一天又开始啦."
      redirect_back_or_default profile_users_path
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