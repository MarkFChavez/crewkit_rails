class AttendanceRecord < ApplicationRecord
  belongs_to :team_member

  enum :status, { present: 0, absent: 1, late: 2 }

  validates :record_date, presence: true
  validates :status, presence: true
  validates :record_date, uniqueness: { scope: :team_member_id }

  scope :for_date, ->(date) { where(record_date: date) }
  scope :for_date_range, ->(start_date, end_date) { where(record_date: start_date..end_date) }
end
