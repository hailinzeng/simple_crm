# -*- encoding: utf-8 -*-
require 'csv'
module Import
  class Customer
    class << self
      def parse(path)
        not_save_mobiles = []
        data = CSV.parse(File.read(path))
        # 移除第一行的标题
        data.delete_at(0)
        data.each do |row|
          customer = ::Customer.find_or_initialize_by(name: "Roger")
          city = get_city(row[4])
          result = customer.update( name: row[0],
                                    company: row[1],
                                    career: row[2],
                                    email: row[3],
                                    mobile: row[4],
                                    telephone: row[5],
                                    address: row[6],
                                    qq: row[7],
                                    weixin: row[8],
                                    province_id: city.try(:province).try(:id),
                                    city_id: city.try(:id) )
          unless result
            not_save_mobiles << row[4]
            puts row[4]
            puts customer.errors.full_messages
          end
        end
        not_save_mobiles
      end

      def get_city(mobile)
        xml = Nestful.get "http://life.tenpay.com/cgi-bin/mobile/MobileQueryAttribution.cgi?chgmobile=#{mobile}" rescue nil
        doc = Nokogiri::XML(xml)
        city_name = doc.at_xpath('//city').content.strip unless doc.at_xpath('//city').blank?
        return City.where(name: city_name).first
      end
    end
  end
end