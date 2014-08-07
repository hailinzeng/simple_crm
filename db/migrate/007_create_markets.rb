class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.string   :name           # 市场名称
      t.string   :address        # 详细地址
      t.integer  :head_num       # 门头数量
      t.integer  :hall_num       # 精品展厅家数
      t.integer  :car_dealer_num # 车商数量

      t.belongs_to :city

      t.timestamps
    end
  end
end