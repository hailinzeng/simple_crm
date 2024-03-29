# -*- encoding: utf-8 -*-

class User < ActiveRecord::Base
  extend Enumerize
  include Base::Security
  include Redis::Objects

  attr_accessor :password, :password_confirmation

  hash_key :cities    # { city_id => name }
  hash_key :provinces # { province_id => name }

  has_many :customers

  belongs_to :city

  belongs_to :role

  # validates :login, uniqueness: true, length: { within: 3..16 }, presence: true

  def has_province?(province_id)
    self.provinces.keys.include?(province_id)
  end

  def has_city?(city_id)
    self.cities.keys.include?(city_id)
  end

  def add_city!(city)
    self.cities[city.city_id] = city.name if city.present?
  end

  def add_province!(province)
    return unless province.present?
    self.provinces[province.province_id] = province.name
    province.cities.each do |city|
      self.cities[city.city_id] = city.name
    end
  end

  # 待重构
  def customers_area(province_id, city_id)
    if province_id == 'no'
      return find_city_customers(city_id) unless city_id == 'no'
    else
      if city_id == 'no'
        find_province_customers(province_id)
      else
        find_city_customers(city_id)
      end
    end
  end

  def find_city_customers(city_id)
    c = City.where(id: city_id).first
    return c.nil? ? [] : c.customers
  end

  def find_province_customers(province_id)
    p = Province.where(id: province_id).first
    return p.nil? ? [] : p.customers
  end

  def root?
    self.role.name == 'root'
  end

  def self.find_with_login(login, password)
    return nil unless (login.present? && password.present?)
    # 查询用户
    user = User.where( 'login = ? or name = ? or mobile = ?', login, login, login ).first
    # 判断权限
    if user && user.password_clean == password
      return user
    end
    nil
  end

  def self.status
    {
      '待转正' => 0,
      '正式员工' => 1
    }
  end

end