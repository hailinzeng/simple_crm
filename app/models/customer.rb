class Customer < ActiveRecord::Base
  extend Enumerize

  belongs_to :user
  belongs_to :city

  has_many :communications

  enumerize :status, in: { loss: -1, inactive: 0, active: 1 }, predicates: { prefix: true }, scope: :having_status

  scope :in_city, ->(city_id) { where(city_id: city_id) }
  scope :between_date, ->(start_at, end_at) { where('created_at >= ? and created_at <= ?',
                                                     start_at.to_date.beginning_of_day,
                                                     end_at.to_date.end_of_day) }
  scope :search_by, ->(name, mobile) { where('name = ? or mobile = ?', name, mobile).first }

  before_create :mark_import_at
  def mark_import_at
    self.import_at = Time.now
  end

end