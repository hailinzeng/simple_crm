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

  # 批量注册
  class User
    class << self
      def parse(path)
        data = CSV.parse(File.read(path))
        data.delete_at(0)
        data.delete_at(0)
        data.each do |row|
          user = ::User.create( parent_id: get_parent_id(row[1]),
                                name: row[2],
                                role_id: get_role_id(row[3]),
                                mobile: row[4],
                                status: ::User.status[row[5]],
                                password: row[4],
                                password_confirmation: row[4]
                              )
          if row[6].present?
            province_names = row[6].split(',')
            province_names.each do |p_name|
              user.add_province!(::Province.where(name: p_name).first)
            end
          end

          if row[7].present?
            city_names = row[7].split(',')
            city_names.each do |c_name|
              user.add_city!(::City.where(name: c_name).first)
            end
          end
        end
      end

      def get_parent_id(name)
        ::User.where(name: name).first.try(:id) if name.present?
      end

      def get_role_id(name)
        ::Role.where(label: name).first.try(:id)
      end
    end
  end

  # 导入市场
  class Market
    class << self
      def parse(path)
        data = CSV.parse(File.read(path))
        data.delete_at(0)
        data.each do |row|
          ::Market.create(name: row[1], city: ::City.where(name: row[0]).first)
        end
      end
    end
  end
end