module UsersHelper

	def provinces
		{'不限省份' => 'no'}.merge(@current_user.provinces.all.invert)
	end

	def cities
		{'不限城市' => 'no'}.merge(@current_user.cities.all.invert)
	end

end