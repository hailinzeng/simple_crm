# -*- encoding: utf-8 -*-

class City < ActiveRecord::Base

  has_many :customers # 客户
  has_many :salesmen, class_name: "User"

  belongs_to :province

  scope :cities_by_province, ->(province) { where(region_chn: province) }

  # 该城市的客户总数
  def customers_count
    self.customers.count
  end

  # 该城市的销售员总数
  def salesmen_count
    self.salesmen.count
  end

end