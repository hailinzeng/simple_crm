# -*- coding: utf-8 -*-

class AdminController < ApplicationController
  include AdminHelper

  before_filter :current_user
  before_filter :admin?
  before_filter :find_saler, only: [ :edit_city, :permission_assign ]

  def index
    @salesmen = User.salesmen.page(params[:page]).per(params[:per_page])
  end

  def edit_city; end

  def permission_assign
    case params[:key]
    when 'province'
      province = Province.where(name: params[:name]).first
      @saler.add_province!(province) unless province.nil?
    when 'city'
      city = City.where(name: params[:name]).first
      @saler.add_city!(city) unless city.nil?
    end

    redirect_to admin_index_path, success: '恭喜你，添加成功。'
  end

  private
    def find_saler
      @saler = User.where(id: params[:saler_id]).first
      redirect_to admin_index_path, error: '该销售员不存在.' if @saler.nil?
    end

end