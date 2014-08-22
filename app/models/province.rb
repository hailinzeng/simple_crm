# -*- encoding: utf-8 -*-

class Province < ActiveRecord::Base

  has_many :cities   
  has_many :customers # 客户

  def self.labels
    Province.pluck(:name, :province_id)
  end

  def city_labels
    [['不限城市', 'no']] + self.cities.pluck(:name, :city_id)
  end

  def self.find_by_id(id)
    Province.where(province_id: id).first
  end

end