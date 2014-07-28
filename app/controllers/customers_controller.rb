# -*- encoding: utf-8 -*-

class CustomersController < ApplicationController
  include CustomersHelper

  before_filter :current_user
  before_filter :find_customer,   only: [ :show, :update ]
  before_filter :find_permission, only: [ :count_area ]
  before_filter :cache_data,      only: [ :index, :count_area ]

  def new
    @customer = Customer.new
    @customers = @current_user.customers.page(params[:page]).per(params[:per_page])
  end

  def create
    resp = Nestful.post "#{GATEWAY_URL}/crm/getOneUserActiveData", { mobile: params[:customer][:mobile] } rescue nil
    @customer = @current_user.customers.new(customer_params)
    if resp.nil?
      flash[:warning] = '该用户没有注册大搜车'
      render 'new'
    else
      if @customer.save
        flash[:success] = '客户已添加'
      else
        flash[:error] = @customer.errors.full_messages
      end
      redirect_to new_customer_path
    end
  end

  def update
    if @customer.update(customer_params)
      flash[:success] = '已保存'
    else
      flash[:error] = @customer.errors.full_messages
    end
    redirect_to customer_path(@customer)
  end

  def show
    @communications = @customer.communications.page(params[:page]).per(5)
    @communication = @customer.communications.new
    render layout: "session"
  end

  def search
    @customer = Customer.search_by(params[:name], params[:mobile]).first
    # 如果本地没有该客户，则实时获取，否则取本地数据库
    if @customer.nil?
      @remote_customer = get_remote_customer
      if @remote_customer.nil?
        flash[:warning] = t('user_not_exist')
        redirect_to profile_users_path
      else
        render 'show', layout: "session"
      end
    else # 本地存在该客户时可查看增加沟通记录
      redirect_to customer_path(@customer)
    end
  end

  def index
    data = get_remote_customers({      pageNo: params[:page],
                                     pageSize: params[:per_page],
                                    cityStdId: params[:city_id],
                                   regDateEnd: params[:end_at],
                                 regDateBegin: params[:start_at],
                                 activeStatus: params[:status],
                                provinceStdId: params[:province_id],
                               })

    @customers, @count = [ data['userList'], data['count'] ]
  end

  def count_area
    opts = {}
    opts[:provinceStdId] = @province_id unless @province_id.blank?
    unless @city_id.blank?
      opts[:cityStdId] = @city_id
      city = City.where(city_id: @city_id).first
      opts[:provinceStdId] = city.province.province_id
    end

    data = Customer.count_area_customers(opts)
    unless data.blank?
          @loss_customers_count = data['loss_count']
        @active_customers_count = data['active_count']
      @inactive_customers_count = data['inactive_count']
      @customers_count = @loss_customers_count + @inactive_customers_count + @active_customers_count
    end
    render 'users/profile'
  end

  # 拍摄名片
  def capture_card
    render layout: nil
  end

  def card_analyze
    #resp = Camcard::Analyzer.parse(params[:upfile])
  end

  private
    def customer_params
      params.require(:customer).permit( :city_id, :name, :email, :mobile, :birthday, 
                                        :market, :company, :career, :scale, :address,
                                        :comment, :province_id, :telephone, :qq, :weixin,
                                        :department)
    end

    def get_remote_customer
      opts = {}
      opts[:mobile] = params[:mobile] if params[:mobile].present?
      opts[:name] = params[:name] if params[:name].present?
      resp = Nestful.post "#{GATEWAY_URL}/crm/getOneUserActiveData", opts rescue nil
      return JSON.parse(resp.body)['data'] unless resp.nil?
    end

    def get_remote_customers(opts)
      opts.delete_if{|k, v| v.nil?}
      resp = Nestful.post "#{GATEWAY_URL}/crm/getUserActiveStatusList", opts rescue nil
      if resp.nil?
        flash[:error] = '服务器请求错误。'
      else
        return JSON.parse(resp.body)['data']
      end
    end

    def get_customers(opts={})
      get_list_of_records(Customer, opts) do |scoped|
        scoped = scoped.in_city(opts[:city_id]) if opts[:city_id].present?
        scoped = scoped.having_status(opts[:status]) if opts[:status].present?
        scoped
      end
    end

    def find_customer
      @customer = Customer.where(id: params[:id]).first
      if @customer.nil?
        flash[:error] = "客户不存在."
        redirect_to customers_path
      end
    end

    def cache_data
           @end_at = params[:end_at]
           @status = params[:status]
          @city_id = params[:city_id] if params[:city_id] != 'no'
         @start_at = params[:start_at]
      @province_id = params[:province_id] if params[:province_id] != 'no'
    end

    def find_permission
      unless find_country_permission?
        unless find_province_permission? || find_city_permission?
          flash[:error] = t('without_permission_tip')
          redirect_to profile_users_path
        end
      end
    end

    def find_province_permission?
      @current_user.has_province?(params[:province_id])
    end

    def find_city_permission?
      @current_user.has_city?(params[:city_id])
    end

    def find_country_permission?
      unless @current_user.role_root?
        if (params[:province_id] == 'no' && params[:city_id] == 'no') || params[:province_id].blank? && params[:city_id].blank?
          flash[:error] = t('without_permission_tip')
          return false
        end
      end
      true
    end

end