# -*- encoding: utf-8 -*-

class UsersController < ApplicationController
  include UsersHelper
  before_filter :current_user, only: [ :profile, :update, :customers ]

  def new
    @user = User.new
    render layout: "session"
  end

  def create
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
    @city_id = @current_user.cities.keys.first
    @province_id = @current_user.cities.keys.first
    if @city_id.nil? && @province_id.nil? && !@current_user.role_root?
      flash[:error] = '您还没有任何权限。'
    else
      opts = {}
      opts[:cityStdId] = @city_id unless @city_id.nil?
      city = City.where(city_id: @city_id).first
      opts = { cityStdId: @city_id, provinceStdId: city.try(:province).try(:province_id) }
      data = Customer.count_area_customers(opts)
      unless data.blank?
        @loss_customers_count = data['loss_count']
        @inactive_customers_count = data['inactive_count']
        @active_customers_count = data['active_count']
        @customers_count = @loss_customers_count + @inactive_customers_count + @active_customers_count
      end
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
                                    :role, :name, :email, :mobile )
    end

end