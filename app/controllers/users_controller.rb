# -*- encoding: utf-8 -*-

class UsersController < ApplicationController
  include UsersHelper

  def new
    @user = User.new
    render layout: "session"
  end

  def create
    @user = User.new user_params
    if @user.save
      set_current_user(@user)
      flash[:success] = '注册成功,等待管理员审核.'
      redirect_to profile_index_path
    else
      flash[:error] = @user.errors.full_messages
      render 'new', layout: "session"
    end
  end

  private
    def user_params
      params.require(:user).permit( :login, :password, :password_confirmation, 
                                    :role_id, :name, :email, :mobile )
    end

end