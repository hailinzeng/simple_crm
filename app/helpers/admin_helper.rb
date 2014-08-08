module AdminHelper

	def places
		{
			'省份' => :province,
			'城市' => :city
		}
	end

  # 目前地推人员负责区域精确到省
  def saler_places(saler)
    return '全国' if saler.root?
    saler.provinces.values.join(', ')
  end

  def has_menu?(role_id, key)
    role = Role.where(id: role_id).first
    role.menus.pluck(:key).include?(key) if role
  end

  def to_bool(str)
    str.to_s == "true" ? true : false
  end

end