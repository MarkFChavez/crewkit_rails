class HoursController < ApplicationController
  def index
    @team_filter = params[:team_id]
    @date_start = params[:date_start] ? Date.parse(params[:date_start]) : Date.today.beginning_of_month
    @date_end = params[:date_end] ? Date.parse(params[:date_end]) : Date.today

    # Get all teams for the dropdown
    @all_teams = Team.active.order(:name)

    # Only load data if a team is selected (performance optimization)
    if @team_filter.present?
      @teams = Team.active.includes(team_members: :hours_logs).where(id: @team_filter)
      @hours_logs = HoursLog.includes(team_member: :team)
                            .joins(:team_member)
                            .where(log_date: @date_start..@date_end)
                            .where(team_members: { team_id: @team_filter })
                            .order(log_date: :desc, 'team_members.name': :asc)
    else
      @teams = Team.none
      @hours_logs = HoursLog.none
    end
  end

  def bulk_update
    hours_params = params[:hours] || {}

    hours_params.each do |member_id, data|
      team_member = TeamMember.find(member_id)
      log = team_member.hours_logs.find_or_initialize_by(log_date: data[:log_date])
      log.hours = data[:hours]
      log.deliverable_notes = data[:deliverable_notes]
      log.save if log.hours.present?
    end

    redirect_to hours_path, notice: "Hours updated successfully"
  end

  def edit
    @log = HoursLog.find(params[:id])
    @team_member = @log.team_member
  end

  def update
    @log = HoursLog.find(params[:id])
    if @log.update(hours_params)
      redirect_to hours_path, notice: "Hours log updated"
    else
      redirect_to hours_path, alert: "Failed to update hours log"
    end
  end

  private

  def hours_params
    params.require(:hours_log).permit(:hours, :deliverable_notes)
  end
end
