class SearchController < ApplicationController
  def team_members
    query = params[:q].to_s.strip

    if query.blank?
      render json: { results: [] }
      return
    end

    results = TeamMember.search(query)
                        .includes(:team)
                        .limit(10)
                        .map do |member|
      {
        id: member.id,
        name: member.name,
        role: member.role,
        email: member.email,
        team_name: member.team.name,
        team_id: member.team.id
      }
    end

    render json: { results: results }
  end
end
