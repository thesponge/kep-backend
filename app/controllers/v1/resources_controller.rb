class V1::ResourcesController < ApplicationController
  before_action :authenticate_with_token!, only: [ :create, :update, :destroy]

  def index
    render json: Resource.all
  end

  def show
    render json: Resource.find(params[:id])
  end

  def create
    resource = current_user.resources.build(resource_params)
    if resource.save
      render json: resource, status: 201
    else
      render json: { errors: resource.errors }, status: 422
    end
  end

  def update
    resource = current_user.resources.find(params[:id])
    if resource.update(resource_params)
      render json: resource, status: 200
    else
      render json: { errors: resource.errors }, status: 422
    end
  end

  def destroy
    resource = current_user.resources.find(params[:id])
    if resource.destroy
      render json: {}, status: 204
    else
      render json: {errors: resource.errors.full_messages}, status: 422
    end
  end

  def state
    resource = current_user.resources.find(params[:resource_id])
    resource.state_event = "#{params[:event]}"
    if resource.save
      render json: resource, status: 200
    else
      render json: resource.errors.full_messages, status: 422
    end
  end


  private

  def resource_params
    params.require(:resource).permit(:event, :title, :description,  intention_ids: [],
     priority_ids: [])
  end

end
