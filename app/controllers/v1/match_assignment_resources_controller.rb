class V1::MatchAssignmentResourcesController < ApplicationController

 # TEST THIS GUY WHEN YOU GET TO INTERNET!!!!!!

  def show
    render json: MatchAssignmentResource.find(params[:id])
  end

  def create
    match = current_user.match_assignment_resources.build(match_assignment_resource_params)
    if match.save!
      ManualMatchMailer.match_ar_assign(Assignment.find(match.assignment_id),
       Resource.find(match.resource_id), User.find(match.matcher_id)).deliver_now
      ManualMatchMailer.match_ar_resource(Assignment.find(match.assignment_id),
       Resource.find(match.resource_id), User.find(match.matcher_id)).deliver_now
      render json: match, status: 201
    else
      render json: match.errors, status: 422
    end
  end

  private

  def match_assignment_resource_params
    params.require(:match_assignment_resource).permit(:assignment_id, :resource_id, :matcher_id)
  end

end
