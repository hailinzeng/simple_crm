# -*- encoding: utf-8 -*-

class CommunicationsController < ApplicationController

  before_filter :find_customer

  def new
    @communication = @customer.communications.new
    render layout: "session"
  end

  def create
    @communication = @customer.communications.new(communication_params)
    if @communication.save
      flash[:success] = '添加成功。'
    else
      flash[:error] = @communication.errors.full_messages.first
    end
    redirect_to customer_path(@customer)
  end

  def index
    @communications = @customer.communications.page(params[:page]).per(params[:per_page])
    render layout: 'session'
  end

  private
    def communication_params
      params.require(:communication).permit( :name, :channel, :comment )
    end

    def find_customer
      @customer = Customer.where(id: params[:customer_id]).first
      if @customer.nil?
        flash[:error] = "客户不存在."
        redirect_to customers_path
      end
    end

    def get_communications(opts={})
      get_list_of_records(Communication, opts) do |scoped|
        scoped
      end
    end

end