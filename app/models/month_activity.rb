class MonthActivity < ApplicationRecord
  belongs_to :team
  belongs_to :dispute_month

  scope :active, -> { where(active: true) }

  def pay(value)
    self.payed_value = value
    self.save
  end
end
