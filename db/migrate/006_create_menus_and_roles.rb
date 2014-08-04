class CreateMenusAndRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string    :name
      t.string    :label
      t.text      :permission

      t.timestamps
    end

    create_table :menus do |t|
      t.string    :key
      t.string    :name
      t.string    :url
      t.text      :options
      t.integer   :parent_id

      t.timestamps
    end

    create_table :menus_roles, id: false do |t|
      t.belongs_to :role
      t.belongs_to :menu
    end
  end
end