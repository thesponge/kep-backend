class V1::PrioritiesController < ApplicationController
   before_action :authenticate_with_token!, only: [:create,:destroy]


  def show
    render json: Priority.find(params[:id])
  end

  def create
    prior = Priority.create(priotity_params)
    if prior.save
      render json: prior, status: 200
    else
      render json: { errors: prior.errors }, status: 422
    end
  end

  def batch_create
    priorities = Priority.batch_create(request[:priorities].to_json)
    if priorities
      render json: priorities, status: 201
    else
      render json: {errors: priorities.errors}, status: 422
    end
  end

  def batch_update
    priorities = Priority.batch_update(request[:priority].to_json)
    if !(priorities.to_a.empty?)
      render json: priorities, status: 201
      print priorities
    else
      render json: {errors: priorities.errors}, status: 422
    end
  end


  protected

  def priotity_params
    params.require(:priority).permit(:user_id, :level, :no_hours, :prioritable_type,
     :prioritable_id)
  end

end
