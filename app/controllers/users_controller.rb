# -*- encoding: utf-8 -*-

class UsersController < ApplicationController

  before_filter :find_user, only: [ :show, :update ]
  before_filter :find_city, only: [ :show, :customers ]

  def new
    @user = User.new
    render layout: "session"
  end

  def create
    @user = User.new user_params
    if @user.save
      set_current_user(@user)
      flash[:success] = "注册成功,等待管理员审核."
      redirect_to user_url(@user)
    else
      flash[:error] = @user.errors.full_messages.first
      render 'new', layout: "session"
    end
  end

  def show
    @city_customers_count = @city.customers_count
    customers = @city.customers
    @loss_customers_count = customers.having_status(:loss).count
    @inactive_customers_count = customers.having_status(:inactive).count
    @active_customers_count = customers.having_status(:active).count
  end

  def update
    if @user.update user_params
      flash[:success] = "修改成功啦."
    else
      flash[:error] = @user.error.full_messages.first
    end
    render 'show'
  end

  def customers
    @customers = @user.customers.page(params[:page]).per(params[:per_page])
  end

  private
    def user_params
      params.require(:user).permit( :login, :password, :password_confirmation, 
                                    :role, :name, :email, :mobile, :city_id )
    end

    def find_user
      @user = User.where(id: params[:id]).first
      redirect_to '/' if @user.nil?
    end

    def find_city
      @city = @user.city
      if @city.nil?
        flash[:error] = "您还没有设置所在的城市."
        redirect_to user_path(@user)
      end
    end

end