class V1::MatchUserResourcesController < ApplicationController
  before_action :authenticate_with_token!, only: [ :create ]
  rescue_from ActiveRecord::RecordNotUnique, with: :not_uniq


  def show
    render json: MatchUserResource.find(params[:id])
  end

  def create
    match = current_user.ur_matches.build(match_user_resource_params)
    if match.save
      render json: match, status: 201
    else
      render json: match.errors, status: 422
    end
  end

  private

  def match_user_resource_params
    params.require(:match_user_resource).permit(:nominee_id,:resource_id,)
  end


  def not_uniq
    render json: {notice: "A match between the selected user and resource already exists"} , status: 304
  end

end
