# -*- encoding: utf-8 -*-

class CustomersController < ApplicationController

  before_filter :current_user
  before_filter :find_city, only: [ :show ]
  before_filter :find_customer, only: [ :show ]

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to new_customer_path, notice: '客户已添加' and return
    else
      redirect_to new_customer_path, alert: @customer.errors.full_messages and return
    end
  end

  def show
    @communications = @customer.communications.page(1).per(5)
    @communication = @customer.communications.new
    render layout: "session"
  end

  def index
    @customers = get_customers( { status: params[:status], city_id: @current_user.city_id } )
  end

  def search
    @customer = Customer.search_by(params[:name], params[:mobile])
    redirect_to customer_path(@customer)
  end

  # 拍摄名片
  def capture_card
    render layout: nil
  end

  def card_analyze
    #resp = Camcard::Analyzer.parse(params[:upfile])
    puts "-"*80
    puts resp
    puts "-"*80
  end

  private
    def customer_params
      params.require(:customer).permit( :city_id, :name, :email, :mobile, :birthday, 
                                        :market, :company, :career, :scale, :address,
                                        :comment)
    end

    def get_customers(opts={})
      get_list_of_records(Customer, opts) do |scoped|
        scoped = scoped.in_city(opts[:city_id]) if opts[:city_id].present?
        scoped = scoped.having_status(opts[:status]) if opts[:status].present?
        scoped
      end
    end

    def find_city
      @city = @current_user.city
      if @city.nil?
        flash[:error] = "您还没有设置所在的城市."
        redirect_to user_path(@current_user)
      end
    end

    def find_customer
      @customer = Customer.where(id: params[:id]).first
      if @customer.nil?
        flash[:error] = "客户不存在."
        redirect_to customers_path
      end
    end

end