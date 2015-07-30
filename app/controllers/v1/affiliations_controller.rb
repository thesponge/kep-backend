class V1::AffiliationsController < ApplicationController
  require "addressable/uri"

  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  def index
    render json: Affiliation.all
  end

  def show
    render json: Affiliation.find(params[:id])
  end

  def create
    # aff = current_user.account.affiliations.build(affiliation_params)
    # aff.link = aff.normal_link(aff.link)
    params[:link] = normalize_link(params[:link])
    aff = Affiliation.find_or_create_by(link: params[:link])
    aff.update_attributes(affiliation: params[:affiliation])
    if aff
       render json: aff, status: 200
    else
      render json: { errors: aff.errors }, status: 422
    end
  end

  protected

  def affiliation_params
    params.require(:affiliation).permit(:affiliation, :link, account_ids: [])
  end

  def normalize_link(link)
    normal_link = Addressable::URI.parse(link).host
    return normal_link
  end

end
