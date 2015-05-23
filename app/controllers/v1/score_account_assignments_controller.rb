class V1::ScoreAccountAssignmentsController < ApplicationController


  def show
    render json: ScoreAccountAssignment.find(params[:id])
  end

  def account_matches
    render json: ScoreAccountAssignment.where(account_id: params[:account_id])
  end

  def assignment_matches
    render json: ScoreAccountAssignment.where(assignment_id: params[:assignment_id])
  end

  protected

  def score_account_assignment_params
    params.require(:score_account_assignment).permit(:id,:account_id,:assignment_id)
  end

end
