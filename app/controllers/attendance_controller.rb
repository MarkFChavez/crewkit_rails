class AttendanceController < ApplicationController
  def index
    @team_filter = params[:team_id]
    @date_start = params[:date_start] ? Date.parse(params[:date_start]) : Date.today.beginning_of_month
    @date_end = params[:date_end] ? Date.parse(params[:date_end]) : Date.today

    # Get all teams for the dropdown
    @all_teams = Team.active.order(:name)

    # Only load data if a team is selected (performance optimization)
    if @team_filter.present?
      @teams = Team.active.includes(team_members: :attendance_records).where(id: @team_filter)
      @attendance_records = AttendanceRecord.includes(team_member: :team)
                                            .joins(:team_member)
                                            .where(record_date: @date_start..@date_end)
                                            .where(team_members: { team_id: @team_filter })
                                            .order(record_date: :desc, 'team_members.name': :asc)
    else
      @teams = Team.none
      @attendance_records = AttendanceRecord.none
    end
  end

  def quick_entry
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @team_filter = params[:team_id]

    # Get all teams for the dropdown
    @all_teams = Team.active.order(:name)

    # Only load team members if a team is selected (performance optimization)
    if @team_filter.present?
      @teams = Team.active.includes(:team_members).where(id: @team_filter)
    else
      @teams = Team.none
    end
  end

  def bulk_update
    attendance_params = params[:attendance] || {}

    attendance_params.each do |member_id, data|
      team_member = TeamMember.find(member_id)
      record = team_member.attendance_records.find_or_initialize_by(record_date: data[:record_date])
      record.status = data[:status]
      record.notes = data[:notes]
      record.save
    end

    redirect_to attendance_quick_entry_path(date: params[:date]), notice: "Attendance updated successfully"
  end

  def edit
    @record = AttendanceRecord.find(params[:id])
    @team_member = @record.team_member
  end

  def update
    @record = AttendanceRecord.find(params[:id])
    if @record.update(attendance_params)
      redirect_to attendance_path, notice: "Attendance record updated"
    else
      redirect_to attendance_path, alert: "Failed to update attendance record"
    end
  end

  private

  def attendance_params
    params.require(:attendance_record).permit(:status, :notes)
  end
end
