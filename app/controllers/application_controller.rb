class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_list_of_records(klass, options = {}, &block)
    scope = klass.page(params[:page]).per(params[:per_page])
    scope = scope.between_date(params[:start_at], params[:end_at]) if params[:start_at].present? && params[:end_at].present?
    scope = yield scope if block_given?
    scope
  end

  protected

    def require_user
      if request.xhr?
        unless current_user
          result = {
            :success => false,
            :msg     => '请先登录帐号'
          }
          respond_to do |format|
            format.json { render :json => result }
          end
        end
      else
        redirect_to new_session_path
      end
    end

    def logout
      session.delete(:user_id)
      @current_user = nil
    end

    def store_location(path = nil)
      session[:return_to] = path || request.fullpath
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def redirect_referrer_or_default(default)
      redirect_to(request.referrer || default)
    end

end