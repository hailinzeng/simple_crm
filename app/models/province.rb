# -*- encoding: utf-8 -*-

class Province < ActiveRecord::Base

  has_many :cities   
  has_many :customers # 客户

  def self.labels
    Province.pluck(:name, :province_id)
  end

  def city_labels
    self.cities.pluck(:name, :city_id)
  end

end