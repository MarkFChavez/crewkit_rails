class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :archive, :activate]

  def index
    @active_teams = Team.active.order(created_at: :desc)
    @archived_teams = Team.archived.order(created_at: :desc)
  end

  def show
    @team_members = @team.team_members.order(:name)
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to @team, notice: "Team created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: "Team updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_path, notice: "Team deleted successfully"
  end

  def archive
    @team.update(active: false)
    redirect_to teams_path, notice: "Team archived"
  end

  def activate
    @team.update(active: true)
    redirect_to teams_path, notice: "Team activated"
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :company, :description, :active)
  end
end
