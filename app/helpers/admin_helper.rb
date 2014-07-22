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

end