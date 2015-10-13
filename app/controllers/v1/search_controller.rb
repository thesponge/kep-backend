class V1::SearchController < ApplicationController

  def assignment_search
    begin
      results = instantiate_search AssignmentSearch
      assignments = results.map {|e| e._data}
      render json: assignments.to_json, status: 200
    rescue => err
      render json: { message: err.to_s } , status: 422
    end
  end

  def resource_search
    begin
      results = instantiate_search ResourceSearch
      resources= results.map {|e| e._data}
      render json: resources.to_json, status: 200
    rescue => err
      render json: { message: err.to_s } , status: 422
    end
  end

  def account_search
    begin
      results = instantiate_search AccountSearch
      accounts = results.map {|e| e._data}
      render json: accounts.to_json, status: 200
    rescue => err
      render json: { message: err.to_s } , status: 422
    end
  end

  private

  def search_params
    params.permit(:id, :title, :description, :state, :progress_percent, :start_date, :end_date,
                  :created_at, :updated_at, :published_at, :owner_id, :owner_email, :owner_name,
                  :locations, :languages, :skills, :assignment_bids, :assignment_rewards, :intentions)
  end

  def instantiate_search klass
    class_name = klass.to_s
    query = Object.const_get(class_name).new(params[:search].deep_symbolize_keys)
    results = query.search
  end

end
