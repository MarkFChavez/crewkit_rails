require 'csv'

class ExportController < ApplicationController
  def attendance
    @date_start = params[:date_start] ? Date.parse(params[:date_start]) : Date.today.beginning_of_month
    @date_end = params[:date_end] ? Date.parse(params[:date_end]) : Date.today
    @team_id = params[:team_id]

    records = AttendanceRecord.includes(team_member: :team)
                              .where(record_date: @date_start..@date_end)
    records = records.where(team_members: { team_id: @team_id }) if @team_id.present?

    respond_to do |format|
      format.csv do
        csv_data = CSV.generate(headers: true) do |csv|
          csv << ['Date', 'Team', 'Member Name', 'Role', 'Status', 'Notes']

          records.order(:record_date, 'teams.name', 'team_members.name').each do |record|
            csv << [
              record.record_date,
              record.team_member.team.name,
              record.team_member.name,
              record.team_member.role,
              record.status,
              record.notes
            ]
          end
        end

        send_data csv_data, filename: "attendance_#{@date_start}_to_#{@date_end}.csv"
      end
    end
  end

  def hours
    @date_start = params[:date_start] ? Date.parse(params[:date_start]) : Date.today.beginning_of_month
    @date_end = params[:date_end] ? Date.parse(params[:date_end]) : Date.today
    @team_id = params[:team_id]

    logs = HoursLog.includes(team_member: :team)
                   .where(log_date: @date_start..@date_end)
    logs = logs.where(team_members: { team_id: @team_id }) if @team_id.present?

    respond_to do |format|
      format.csv do
        csv_data = CSV.generate(headers: true) do |csv|
          csv << ['Date', 'Team', 'Member Name', 'Role', 'Hours', 'Deliverable Notes']

          logs.order(:log_date, 'teams.name', 'team_members.name').each do |log|
            csv << [
              log.log_date,
              log.team_member.team.name,
              log.team_member.name,
              log.team_member.role,
              log.hours,
              log.deliverable_notes
            ]
          end
        end

        send_data csv_data, filename: "hours_#{@date_start}_to_#{@date_end}.csv"
      end
    end
  end
end
