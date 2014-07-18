module ApplicationHelper

  # 百分比
  def percentage(num, total)
    percentage = if total <= 0
                   "0.00%"
                 else
                   number_to_percentage((num / total.to_f) * 100)
                 end
    "占比: #{percentage}"
  end

  def format_datetime(time)
    time.strftime('%Y-%m-%d') unless time.nil?
  end

  def logined?
    !!current_user
  end

  def set_current_user(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def current_user
    @current_user ||= login_from_session unless defined?(@current_user)
    @current_user
  end

  def admin?
    @current_user.role_root?
  end

  def login_from_session
    if session[:user_id].present?
      begin
        User.find session[:user_id]
      rescue
        session[:user_id] = nil
      end
    end
  end

end