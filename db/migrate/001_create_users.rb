class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :login       # 用户名
      t.string   :name        # 姓名
      t.string   :email       # 邮箱
      t.string   :mobile      # 手机号码
      t.integer  :status      # 0：待转正；1：正式员工
      t.boolean  :active,     # 用户是否激活

      t.string   :salt
      t.string   :crypted_password

      t.integer  :parent_id   # 上级

      t.belongs_to :role      # 角色
      t.belongs_to :city      # 城市

      t.timestamps
    end
    
    add_index :users,   :login,   :unique => true
  end
end