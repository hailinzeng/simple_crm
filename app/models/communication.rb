class Communication < ActiveRecord::Base
  extend Enumerize
  belongs_to :customer

  enumerize :channel, in: { sms: 1, push_in: 2, call_out: 3, other: 4 }, predicates: { prefix: true }, scope: true

end