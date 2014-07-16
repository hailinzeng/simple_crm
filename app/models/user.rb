# -*- encoding: utf-8 -*-

class User < ActiveRecord::Base
  extend Enumerize
  include Base::Security

  attr_accessor :password, :password_confirmation

  has_many :customers

  belongs_to :city

  enumerize :role, in: { saler: 1, sale_leader: 2, sale_director: 3, developer: 4, root: 99 }, predicates: { prefix: true }, scope: true

  validates :login, uniqueness: true, length: { within: 3..16 }, presence: true

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