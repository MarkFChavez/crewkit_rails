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
  end
end
