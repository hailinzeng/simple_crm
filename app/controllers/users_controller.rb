# -*- encoding: utf-8 -*-

class UsersController < ApplicationController
  include UsersHelper
  before_filter :current_user,    only: [ :profile, :update, :customers ]
  before_filter :find_permission, only: [ :profile, :customers ]

  def new
    @user = User.new
    render layout: "session"
  end

  def create
    # 临时处理用户输入城市取城市id，后面使用select2 传city_id 处理
    city = City.where(name_chn: params[:user][:city]).first
    params[:user][:city_id] = city.try(:id)
    @user = User.new user_params
    if @user.save
      set_current_user(@user)
      flash[:success] = "注册成功,等待管理员审核."
      redirect_to profile_users_path
    else
      flash[:error] = @user.errors.full_messages
      render 'new', layout: "session"
    end
  end

  def profile
    customers = @current_user.customers_area(params[:province_id], params[:city_id])
    if customers.any?
      @customers_count = customers.count
      @loss_customers_count = customers.having_status(:loss).count
      @inactive_customers_count = customers.having_status(:inactive).count
      @active_customers_count = customers.having_status(:active).count
    end
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
    @customers = @current_user.customers.page(params[:page]).per(params[:per_page])
  end

  private
    def user_params
      params.require(:user).permit( :login, :password, :password_confirmation, 
                                    :role, :name, :email, :mobile, :city_id )
    end

    def find_permission
      default_province_id = @current_user.provinces.empty? ? '' : @current_user.provinces.first[0]
      @province = Province.where(id: params[:province_id] || default_province_id).first
      default_city_id = @current_user.cities.empty? ? '' : @current_user.cities.first[0]
      @city = City.where(id: params[:city_id] || default_city_id).first
    end

end
