class Customer < ActiveRecord::Base
  extend Enumerize

  belongs_to :user
  belongs_to :city
  belongs_to :province

  has_many :communications

  enumerize :status, in: { loss: 0, inactive: 1, active: 2 }, predicates: { prefix: true }, scope: :having_status
  validates :mobile, uniqueness: true, length: { is: 11 }, present: true

  scope :in_city, ->(city_id) { where(city_id: city_id) }
  scope :between_date, ->(start_at, end_at) { where('created_at >= ? and created_at <= ?',
                                                     start_at.to_date.beginning_of_day,
                                                     end_at.to_date.end_of_day) }

  scope :search_by, ->(name, mobile) do
    self.where(name: name) if name.present?
    self.where(mobile: mobile) if mobile.present?
  end
  before_create :mark_import_at
  def mark_import_at
    self.import_at = Time.now
  end

  def self.status
    { 0 => '流失用户', 1 => '非活跃用户', 2 => '活跃用户' }
  end

  def self.count_area_customers(opts)
    resp = Nestful.post "#{GATEWAY_URL}/crm/getUsersActiveView", opts rescue nil
    unless resp.nil?
      result = JSON.parse(resp.body)
      return result['data'] if result["resultId"] == 0
    end
  end

  def market=(market)
    unless market.nil?
        self.market_id = market.id
      self.market_name = market.name
    end
  end

end