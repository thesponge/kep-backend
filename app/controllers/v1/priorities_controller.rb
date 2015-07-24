class V1::PrioritiesController < ApplicationController
   before_action :authenticate_with_token!, only: [:create,:destroy]


  def show
    render json: Priority.find(params[:id])
  end

  def batch_create
    priorities = Priority.batch_create(request[:priorities].to_json)
    if priorities.is_a?(Exception)
      render json: {errors: priorities.to_s}, status: 422
    else
      render json: priorities, status: 201
    end
  end


  protected

  def priotity_params
    params.require(:priority).permit(:id,:chosens_id, :level, :no_hours, :prioritable_id, :prioritable_type)
  end

end
