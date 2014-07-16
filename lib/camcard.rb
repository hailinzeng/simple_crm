# -*- encoding: utf-8 -*-

module Camcard
  class Analyzer

    def self.parse(image)
      base_url = "http://bcr2.intsig.net/BCRService/BCR_VCF2"
      params = "PIN=#{self.pin}&user=#{CAMCARD_COMPANY_EMAIL}&pass=#{CAMCARD_KEY}&lang=#{CAMCARD_LANG}&size=#{image.size}"
      Nestful.post "#{base_url}?#{params}", upfile: image
    end

    def self.pin
      SecureRandom.random_number( ''.ljust(15, '9').to_i )
    end

  end
end