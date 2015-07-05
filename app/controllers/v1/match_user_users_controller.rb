class V1::MatchUserUsersController < ApplicationController
  before_action :authenticate_with_token!, only: [ :create]
  rescue_from ActiveRecord::RecordNotUnique, with: :not_uniq


  def show
    render json: MatchUserUser.find(params[:id])
  end

  def create
    match = current_user.uu_matches.build(match_user_user_params)
    if match.save
      render json: match, status: 201
    else
      render json: match.errors, status: 422
    end
  end

  private

  def match_user_user_params
    params.require(:match_user_user).permit(:nominee_id,:second_nominee_id)
  end


  def not_uniq
    render json: {notice: "A match involving this two people already exists"} , status: 304
  end

end
