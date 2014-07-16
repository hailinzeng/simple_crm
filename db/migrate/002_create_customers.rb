class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string     :name            # 姓名
      t.string     :email           # 邮箱
      t.string     :mobile          # 手机号码
      t.date       :birthday        # 生日
      t.string     :career          # 职业
      t.string     :market          # 市场
      t.string     :company         # 公司
      t.string     :scale           # 规模
      t.string     :address         # 地址

      t.integer    :status          # 活跃(1) || 流失(-1) || 非活跃(0)
      t.string     :comment         # 备注

      t.references :city            # 城市
      t.references :user            # 用户

      t.integer    :publish_cars_count # 发车数量
      t.integer    :collect_cars_count # 收车数量

      t.datetime   :last_login_at   # 上次访问时间
      t.datetime   :last_publish_at # 上次发车时间
      t.datetime   :last_collect_at # 上次收车时间

      t.datetime   :import_at # 录入时间

      t.timestamps
    end
  end
end