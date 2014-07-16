class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :login       # 用户名
      t.string   :name        # 姓名
      t.string   :email       # 邮箱
      t.string   :mobile      # 手机号码
      t.integer  :role        # 角色id
      t.boolean  :active, default: false  # 用户是否激活

      t.string   :salt
      t.string   :crypted_password

      t.references :city      # 城市

      t.timestamps
    end
    
    add_index :users,   :login,   :unique => true
  end
end