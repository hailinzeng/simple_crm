class MenusController < ApplicationController
  before_filter :current_user, :find_role

  def index
    @menus = Menu.where(parent_id: 1)
  end

  def assign
    @role.menus = Menu.where(id: params[:menu_ids])
    if @role.save
      flash[:success] = '保存成功啦。'
    else
      flash[:error] = @role.errors.full_messages
    end
    redirect_to menu_assign_admin_index_path
  end

  private
    def find_role
      @role = Role.where(id: params[:role_id]).first
      redirect_back_or_default '/' if @role.nil?
    end

end