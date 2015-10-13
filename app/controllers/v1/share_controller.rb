class V1::ShareController < ApplicationController

  def create
    begin
      ShareWorker.perform_async(current_user.id, params[:object_class],
        params[:object_id], params[:email])
      render json: {message: "The email will been sent"}, status: 200
    rescue => err
      render json: { message: err.to_s } , status: 422
    end
  end

  private

  def share_params
    params.permit(:email, :object_class, :object_id)
  end

end
