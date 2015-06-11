class V1::AssignmentsController < ApplicationController
  include Wisper::Publisher

  before_action :authenticate_with_token!, only: [ :create, :update, :destroy]

  def index
    assignments = Assignment.filter(params.slice(:title, :travel, :driver_license))
    render json: assignments
  end

  def show
    render json: Assignment.find(params[:id])
  end

  def create
    assignment = current_user.assignments.build(assignment_params)
    if assignment.save
      service =  AutomaticMatches.new()
      service.generate(assignment,assignment_params)
      render json: assignment, status: 201
    else
      render json: { errors: assignment.errors }, status: 422
    end
  end

  def update
    assignment = current_user.assignments.find(params[:id])
    if assignment.update(assignment_params)
      service = AutomaticMatches.new()
      service.update(assignment, assignment_params)
      render json: assignment, status: 200
    else
      render json: { errors: assignment.errors }, status: 422
    end
  end

  def destroy
    assignment = current_user.assignments.find(params[:id])
    if assignment.destroy
      head 204
    else
      render json: {errors: assignment.errors.full_messages}, status: 422
    end
  end

  private

  def assignment_params
    params.require(:assignment).permit(:title, :description, :travel, :driver_license,
     assignment_reward_ids: [], assignment_priority_ids: [], skill_ids: [], location_ids: [],
     language_ids: [], assignment_bid_ids: [])
  end


end
