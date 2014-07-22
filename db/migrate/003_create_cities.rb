class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string         :name        # 城市中文名称
      t.integer        :city_id
      t.references     :province
    end
  end
end