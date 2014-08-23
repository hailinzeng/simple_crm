# -*- encoding: utf-8 -*-

class CustomersController < ApplicationController
  include CustomersHelper

  before_filter :current_user
  before_filter :find_customer,   only: [ :show,  :update ]
  before_filter :find_permission, only: [ :index, :count_area ]
  before_filter :cache_data,      only: [ :index, :count_area ]

  def new
    @customer = Customer.new
  end

  def create
    resp = Nestful.post "#{GATEWAY_URL}/crm/getOneUserActiveData", { mobile: params[:customer][:mobile] } rescue nil
    market = Market.where(id: params[:customer][:market_id]).first
    @customer = @current_user.customers.new(customer_params.merge!(market: market))

    result = if resp.nil?
               { success: false, msg: '该用户没有注册车牛.' }
             else
               if @customer.save
                 { success: true, msg: '客户已添加.', data: { customer_id: @customer.id } }
               else
                 { success: false, msg: @customer.errors.full_messages.first }
               end
             end

    respond_to do |format|
      format.json { render json: result }
    end
  end

  def update
    market = Market.where(id: params[:customer][:market_id]).first
    if @customer.update(customer_params.merge!(market: market))
      flash[:success] = '已保存'
    else
      flash[:error] = @customer.errors.full_messages
    end
    redirect_to customer_path(@customer)
  end

  def show
    params[:name] = @customer.name
    params[:mobile] = @customer.mobile
    @remote_customer = get_remote_customer
    @communications = @customer.communications.page(params[:page]).per(5)
    @communication = @customer.communications.new
    render layout: "session"
  end

  def search
    @customer = Customer.search_by(params[:name], params[:mobile]).first
    @remote_customer = get_remote_customer
    if @customer.nil?
      if @remote_customer.blank?
        flash[:warning] = t('user_not_exist')
        redirect_to profile_index_path
      else
        @customer = Customer.new
        render 'show', layout: "session"
      end
    else
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
    # result = if data.blank?
    #            {}
    #          else
    #            {
    #              detail: @current_user.role.detail?,
    #              loss_customers_count: data['loss_count'],
    #              active_customers_count: data['active_count'],
    #              inactive_customers_count: data['inactive_count'],
    #              customers_count: data['loss_count'] + data['active_count'] + data['inactive_count']
    #            }
    #          end
    # respond_to do |format|
    #   format.json { render json: result }
    # end

    unless data.blank?
      @loss_customers_count = data['loss_count']        
      @active_customers_count = data['active_count']    
      @inactive_customers_count = data['inactive_count']
      @customers_count = @loss_customers_count + @inactive_customers_count + @active_customers_count
    end
    render 'profile/index'
  end

  def manage
      menu = Menu.where(key: 'customer').first
    @menus = @current_user.role.menus.where(parent_id: menu.id) unless menu.nil?
  end

  private
    def customer_params
      params.require(:customer).permit( :city_id, :name, :email, :mobile, :birthday, 
                                        :market, :company, :career, :scale, :address,
                                        :comment, :province_id, :telephone, :qq, :weixin,
                                        :department)
    end

    def get_remote_customer
      opts = { name: @customer.try(:name), mobile: @customer.try(:mobile) }
      resp = Nestful.post "#{GATEWAY_URL}/crm/getOneUserActiveData", opts rescue nil
      unless resp.nil?
        customer = resp.decoded['data'] 
        return customer.blank? ? {} : customer
      end
    end

    def get_remote_customers(opts)
      opts.delete_if{|k, v| v.blank?}
      resp = Nestful.post "#{GATEWAY_URL}/crm/getUserActiveStatusList", opts rescue nil
      if resp.nil?
        flash[:error] = '服务器请求错误。'
      else
        return resp.decoded['data']
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
          redirect_to profile_index_path
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
      unless @current_user.root?
        if (params[:province_id] == 'no' && params[:city_id] == 'no') || params[:province_id].blank? && params[:city_id].blank?
          flash[:error] = t('without_permission_tip')
          return false
        end
      end
      true
    end

end