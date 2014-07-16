class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string         :name_chn        # 城市中文名称
      t.string         :name_eng        # 城市英文
      t.string         :name_pinyin     # 城市拼音

      t.string         :region_chn      # 省中文名称
      t.string         :region_eng      # 省英文
      t.string         :region_pinyin   # 省拼音

      t.string         :country_chn     # 国家中文名称
      t.string         :country_eng     # 国家英文
      t.string         :country_pinyin  # 国家拼音

      t.decimal        :latitude,  :precision => 16, :scale => 8, :default => 0 # 纬度
      t.decimal        :longitude, :precision => 16, :scale => 8, :default => 0 # 经度

      t.timestamps
    end
  end
end