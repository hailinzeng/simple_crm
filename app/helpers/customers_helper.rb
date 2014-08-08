module CustomersHelper

  def default_province
    return @current_user.provinces.first[0] unless @current_user.provinces.empty?
    Province.labels.first[1]
  end

  def start_at
    if @start_at.nil?
      Date.today - 1
    else
      @start_at
    end
  end

  def end_at
    if @end_at.nil?
      Date.today
    else
      @end_at
    end
  end

  def status_label
    if params[:status].present?
      Customer.status[params[:status].to_i]
    else
      t('label_customer_count')
    end
  end

  def customer
    customer = if @customer.present?
                 status = @customer.status.nil? ? nil : t("customer.status.#{@customer.status}")
                 {
                   status: status,
                   last_login_at: @customer.last_login_at,
                   last_publish_at: @customer.last_publish_at,
                   last_collect_at: @customer.last_collect_at,
                   publish_cars_count: @customer.publish_cars_count,
                   collect_cars_count: @customer.collect_cars_count
                 }
               elsif @remote_customer.present?
                 {
                   name: @remote_customer['name'],
                   mobile: @remote_customer['mobile'],
                   status: Customer.status[@remote_customer['active_status'].to_i],
                   last_login_at: @remote_customer['last_active_time'],
                   last_publish_at: @remote_customer['last_publish_time'],
                   last_collect_at: @remote_customer['last_subscribe_time'],
                   publish_cars_count: @remote_customer['publish_count'],
                   collect_cars_count: @remote_customer['subscribe_count']
                 }
               end
  end

  def link_prev_page
    customers_path( page: prev_page,
                    status: @status,
                    end_at: @end_at,
                    city_id: @city_id,
                    start_at: @start_at,
                    province_id: @province_id
                  )
  end

  def link_next_page
    customers_path( page: next_page,
                    status: @status,
                    end_at: @end_at,
                    city_id: @city_id,
                    start_at: @start_at,
                    province_id: @province_id
                  )
  end

end