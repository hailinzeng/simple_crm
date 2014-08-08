module UsersHelper

	def provinces
    if @current_user.root?
      [['不限省份', 'no']] + Province.labels
    else
      {'不限省份' => 'no'}.merge(@current_user.provinces.all.invert)
    end
	end

	def cities(province_id=nil)
    if @current_user.root?
      province = Province.where(province_id: province_id).first
      return [['不限城市', 'no']] + province.city_labels if province.present?
      []
    else
      {'不限城市' => 'no'}.merge(@current_user.cities.all.invert)
    end
	end

end