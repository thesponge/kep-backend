class V1::AssignmentBidsController < ApplicationController
   before_action :authenticate_with_token!, only: [:create]

  def show
    render json: AssignmentBid.find(params[:id])
  end

  def create
    bid = current_user.assignment_bids.build(assignment_bid_params)
    if bid.save
       render json: bid, status: 200
    else
      render json: { errors: bid.errors }, status: 422
    end
  end

  protected

  def assignment_bid_params
    params.require(:assignment_bid).permit(:chosen, :assignment_id)
  end

end
