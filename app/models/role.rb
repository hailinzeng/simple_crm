# -*- encoding: utf-8 -*-
require 'util'

class Role < ActiveRecord::Base
  serialize :permission

  has_many :users

  has_and_belongs_to_many :menus

  def parent_menus
    self.menus.where(parent_id: 1)
  end

  def detail?
    self.permission[:detail]
  end

  def self.labels
    Role.pluck(:label, :id)
  end

end