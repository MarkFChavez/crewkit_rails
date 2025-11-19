class HoursLog < ApplicationRecord
  belongs_to :team_member

  validates :log_date, presence: true
  validates :hours, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :log_date, uniqueness: { scope: :team_member_id }

  scope :for_date, ->(date) { where(log_date: date) }
  scope :for_date_range, ->(start_date, end_date) { where(log_date: start_date..end_date) }
end
