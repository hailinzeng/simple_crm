class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string         :name        # 城市中文名称
      t.integer        :city_id
      t.belongs_to     :province
    end

    add_index :cities, :province_id
  end
end