class V1::MatchAssignmentResourcesController < ApplicationController
  before_action :authenticate_with_token!, only: [ :create ]
  rescue_from ActiveRecord::RecordNotUnique, with: :not_uniq

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
    params.require(:match_assignment_resource).permit(:assignment_id, :resource_id,
     :matcher_id)
  end

  def not_uniq
    render json: {notice: "A match involving this assignment and this resource already exists"} , status: 304
  end
end
