module AdminHelper

	def places
		{
			'省份' => :province,
			'城市' => :city
		}
	end

  def saler_places(saler)
    (saler.provinces.values + saler.cities.values).join(', ')
  end

  def has_menu?(role_id, key)
    role = Role.where(id: role_id).first
    role.menus.pluck(:key).include?(key) if role
  end

  def to_bool(str)
    str == "true" ? true : false
  end

end