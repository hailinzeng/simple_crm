# -*- encoding: utf-8 -*-

class Role < ActiveRecord::Base

  has_many :users

  has_and_belongs_to_many :menus

end