# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  
  navigation.items do |primary|
    if logined?
      primary.item :customers, '客户管理', 'javascript:;' do |customer|
        customer.selected_class = 'ui-btn-active'
        customer.item :new, '添加客户', new_customer_path
        customer.item :index, '客户列表', customers_path
      end
      primary.item :profile, '个人信息', 'javascript:;' do |profile|
        profile.selected_class = 'ui-btn-active'
        profile.item :update, '个人主页',user_path(@current_user)
        profile.item :pwd_reset, '重置密码', user_reset_index_path(@current_user)
      end
    end
  end

end