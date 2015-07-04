class V1::LanguagesController < ApplicationController

  def index
    render json: Language.all
  end

  def show
    render json: Language.find(params[:id])
  end

  protected

  def language_params
    params.require(:language).permit(:id, :iso, :common)
  end

end
