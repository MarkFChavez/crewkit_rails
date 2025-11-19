class TeamMember < ApplicationRecord
  belongs_to :team
  has_many :attendance_records, dependent: :destroy
  has_many :hours_logs, dependent: :destroy

  validates :name, presence: true
  validates :role, presence: true

  # Search scope for global employee search
  scope :search, ->(query) {
    sanitized_query = "%#{sanitize_sql_like(query)}%"
    joins(:team).where(
      "team_members.name LIKE ? OR team_members.email LIKE ? OR teams.name LIKE ?",
      sanitized_query, sanitized_query, sanitized_query
    ).distinct
  }

  def attendance_for_date(date)
    attendance_records.find_by(record_date: date)
  end

  def hours_for_date(date)
    hours_logs.find_by(log_date: date)
  end

  def total_hours_for_range(start_date, end_date)
    hours_logs.where(log_date: start_date..end_date).sum(:hours)
  end

  def attendance_rate_for_range(start_date, end_date)
    total_days = attendance_records.where(record_date: start_date..end_date).count
    return 0 if total_days.zero?

    present_days = attendance_records.where(record_date: start_date..end_date, status: 0).count
    (present_days.to_f / total_days * 100).round(2)
  end
end
