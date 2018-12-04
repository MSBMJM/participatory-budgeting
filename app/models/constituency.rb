class Constituency < ApplicationRecord
  has_many :campaigns

  validates :title, presence: true
  validates :description, presence: true
  validates :active, :boolean, default: false, null: false


  def self.current
    find_by(active: true)
  end

  def current_campaign
    campaigns.find_by(active: true)
    # Rails.logger.debug(self[:title])
    # campaigns.current
  end

end