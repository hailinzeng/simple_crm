# -*- encoding: utf-8 -*-
require 'csv'
module Import
  class Customer
    class << self
      def parse(path)
        data = CSV.parse(File.read(path))
        # 移除第一行的标题
        data.delete_at(0)
        data.each do |row|
          ::Customer.create(name: row[0],
                            company: row[1],
                            career: row[2],
                            email: row[3],
                            telephone: row[4],
                            address: row[5],
                            qq: row[6],
                            weixin: row[7],
                            mobile: (Random.rand*100000000000).to_i.to_s,
                            province_id: city.try(:province).try(:id),
                            city_id: city.try(:id))

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
end