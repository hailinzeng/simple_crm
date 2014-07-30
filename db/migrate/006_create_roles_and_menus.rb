class CreateRolesAndMenus < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string    :name
      t.string    :label

      t.timestamps
    end

    create_table :menus do |t|
      t.string    :name
      t.string    :label

      t.timestamps
    end

    create_table :roles_menus, id: false do |t|
      t.belongs_to :role
      t.belongs_to :menu
    end
  end
end