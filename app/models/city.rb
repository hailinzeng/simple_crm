# -*- encoding: utf-8 -*-

class City < ActiveRecord::Base

  has_many :customers # 客户
  has_many :salesmen, class_name: "User"

  has_many :markets

  belongs_to :province

  # 该城市的客户总数
  def customers_count
    self.customers.count
  end

  # 该城市的销售员总数
  def salesmen_count
    self.salesmen.count
  end

  def self.labels
    City.pluck(:name, :city_id)
  end

end