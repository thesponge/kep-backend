class MatchAssignmentResourcesController < ApplicationController

 # TEST THIS GUY WHEN YOU GET TO INTERNET!!!!!!

  def show
    render json: MatchAssignmentResource.find(params[:id])
  end

  def create
    match_as_re = MatchAssignmentResource.build(match_assignment_resource_params)
    if match_as_re.save!
      render json: match_as_re, status: 201
    else
      render json: match_as_re.errors
    end
  end

  private

  def match_assignment_resource_params
    params.require(:match_assignment_resource).permit(:assignment_id, :resource_id, :matcher_id)
  end

end
