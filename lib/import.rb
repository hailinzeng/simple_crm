# -*- encoding: utf-8 -*-
require 'csv'
module Import
  class Customer
    def self.parse(path)
      data = CSV.parse(File.read(path))
      # 移除第一行的标题
      data.delete_at.each do |row|
        Customer.create(name: ,
                        email: ,
                        mobile: ,
                        career: ,
                        market: ,
                        company: ,
                        scale: ,
                        address: ,
                        comment: ,
                        department: ,
                        qq: ,
                        weixin: ,
                        province_id: city.province.id,
                        city_id: city.id)

      end
    end

    def city
      resp = Nestful.get "http://open.shou65.com/geocoder/#{mobile}" rescue nil
      unless resp.nil?
        data = JSON.parse(resp.body)
        city_name = data['city']
        return City.where(name: city_name).first
      end
    end
  end
end