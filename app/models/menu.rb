class Menu < ActiveRecord::Base

  serialize :options

  has_and_belongs_to_many :roles

  has_many :children, class_name: 'Menu', foreign_key: :parent_id

  belongs_to :parent, class_name: 'Menu'

  default_scope { order('id ASC') }

end