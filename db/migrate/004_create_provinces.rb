class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.string   :name            # 省份
      t.integer  :province_id
    end
  end
end