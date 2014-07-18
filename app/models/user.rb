# -*- encoding: utf-8 -*-

class User < ActiveRecord::Base
  extend Enumerize
  include Base::Security
  include Redis::Objects

  attr_accessor :password, :password_confirmation

  hash_key :cities    # { id => name }
  hash_key :provinces # { id => name }

  has_many :customers

  belongs_to :city

  enumerize :role, in: { saler: 1, sale_leader: 2, sale_director: 3, developer: 4, root: 99 }, predicates: { prefix: true }, scope: true

  validates :login, uniqueness: true, length: { within: 3..16 }, presence: true

  scope :salesmen, -> { where('role < 4') }

  def add_city!(city)
    self.cities[city.id] = city.name
  end

  def add_province!(province)
    self.provinces[province.id] = province.name
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

  def self.roles
    {
        "销售员" => :saler,
      "销售组长" => :sale_leader,
      "销售总监" => :sale_director,
      "开发人员" => :developer,
         "root" => :root
    }
  end

  def self.find_with_login(login, password)
    return nil unless (login.present? && password.present?)
    # 查询用户
    user = User.where(login: login).first
    # 判断权限
    if user && user.password_clean == password
      return user
    end
    nil
  end

end