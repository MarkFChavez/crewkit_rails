class DashboardController < ApplicationController
  def index
    @active_teams = Team.active.includes(:team_members)
    @total_members = TeamMember.joins(:team).where(teams: { active: true }).count

    # Today's attendance
    @todays_attendance = AttendanceRecord.includes(team_member: :team)
                                         .where(record_date: Date.today)
                                         .where(teams: { active: true })

    # This week's hours
    week_start = Date.today.beginning_of_week
    week_end = Date.today.end_of_week
    @this_week_hours = HoursLog.joins(team_member: :team)
                               .where(teams: { active: true })
                               .where(log_date: week_start..week_end)
                               .sum(:hours)

    # Attendance summary for today
    total_tracked_today = @todays_attendance.count
    present_today = @todays_attendance.where(status: :present).count
    @attendance_rate_today = total_tracked_today > 0 ? (present_today.to_f / total_tracked_today * 100).round(2) : 0

    # Weekly attendance data for chart (last 7 days)
    @weekly_attendance_data = prepare_weekly_attendance_data
  end

  private

  def prepare_weekly_attendance_data
    dates = (6.days.ago.to_date..Date.today).to_a

    data = dates.map do |date|
      attendance = AttendanceRecord.joins(team_member: :team)
                                   .where(record_date: date)
                                   .where(teams: { active: true })

      {
        date: date.strftime('%a'), # Mon, Tue, Wed, etc.
        present: attendance.where(status: :present).count,
        absent: attendance.where(status: :absent).count,
        late: attendance.where(status: :late).count
      }
    end

    {
      labels: data.map { |d| d[:date] },
      present: data.map { |d| d[:present] },
      absent: data.map { |d| d[:absent] },
      late: data.map { |d| d[:late] }
    }
  end
end
