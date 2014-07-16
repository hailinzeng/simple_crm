# -*- encoding: utf-8 -*-
require 'crypt'

module Base
  module Security
    extend ActiveSupport::Concern
      included do
        validates :password, length: { within: 6..16 }, presence: true, :if => :password_required
        validates :password_confirmation, length: { within: 6..16 }, presence: true, :if => :verify_password_confirmation

        default_scope { where(active: true) } # 只允许激活的用户登录
        before_save :encrypt_password
      end

      # 用户的密码
      def password_clean
        self.crypted_password.decrypt(salt)
      end

      private
        def verify_password_confirmation
          return false unless password_required
          if self.password == self.password_confirmation
            return true
          else
            self.errors.add(:error, "确认密码与密码不一致.")
          end
          false
        end

        def password_required
          crypted_password.blank? || password.present?
        end

        # Password setter generates salt and crypted_password
        def encrypt_password
          if self.password.present?
            self.salt = secure_token
            self.crypted_password = password.to_s.encrypt( self.salt )
          end
        end

        def secure_token(length = 16)
          SecureRandom.hex(length / 2)
        end

  end
end