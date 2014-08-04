# -*- coding: utf-8 -*-

class AdminController < ApplicationController
  include AdminHelper

  before_filter :current_user
  before_filter :admin?
  before_filter :find_user, only: [ :edit_city, :add_city ]

  def index; end

  def city_assign
    @users = User.page(params[:page]).per(params[:per_page])
  end

  def menu_assign
    @roles = Role.all
  end

  def permission_assign
    @roles = Role.all
  end

  def edit_city; end

  def add_city
    case params[:key]
    when 'province'
      province = Province.where(name: params[:name]).first
      @user.add_province!(province) unless province.nil?
    when 'city'
      city = City.where(name: params[:name]).first
      @user.add_city!(city) unless city.nil?
    end

    redirect_to admin_index_path, success: '恭喜你，添加成功。'
  end

  def update_permission
    params[:permission].each do |role_id, p|
      role = Role.where(id: role_id).first
      role.update(permission: p) if role
    end
    redirect_to admin_index_path
  end

  private
    def find_user
      @user = User.where(id: params[:user_id]).first
      redirect_to admin_index_path, error: '该销售员不存在.' if @user.nil?
    end

end