class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string     :name            # 姓名
      t.string     :email           # 邮箱
      t.string     :mobile          # 手机号码
      t.string     :telephone       # 联系电话
      t.date       :birthday        # 生日
      t.string     :company         # 公司
      t.string     :career          # 职位
      t.string     :department      # 部门
      t.string     :scale           # 规模
      t.string     :address         # 地址
      t.string     :qq              #　QQ
      t.string     :weixin          # 微信

      t.integer    :status          # 流失(0) || 非活跃(1) || 活跃(2)
      t.string     :comment         # 备注

      t.string     :market_name     # 缓存市场名称
      t.belongs_to :market

      t.belongs_to :city            # 城市
      t.belongs_to :province        # 省份
      t.belongs_to :user            # 用户

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