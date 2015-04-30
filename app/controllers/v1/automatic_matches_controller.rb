class V1::AutomaticMatchesController < ApplicationController
  include Matchable

  before_action :authenticate_with_token!, only: [:create, :update,:destroy]

  def index
    render json: AutomaticMatch.where(id_1:request[:id_1],table_name_1: request[:table_name_1])
  end


  def show
    render json: AutomaticMatch.find(params[:id])
  end

  def create
    # automatch = AutomaticMatch.new(automatic_match_params)
    if params[:automatic_match][:table_name_1] == "assignment"
      assign = Assignment.find(params[:automatic_match][:id_1])
      match_assignment(assign)
      render json: {notice: "Automatches have been created. GET on index to see them"},
      status: 200
    else
      render json: {notice: "Shit happened"} ,status: 401
    end
  end

  protected

  def automatic_match_params
    params.require(:automatic_match).permit(:id_1,:table_name_1)
  end


  def match_assignment(assign)
    arr = Account.all
    arr.each do |a|
      automatch = AutomaticMatch.new()
      automatch.id_1 = assign.id
      automatch.table_name_1 = "assignment"
      automatch.table_name_2 = "account"
      automatch.id_2 = a.id
      automatch.total_score = total_score_assign(a,assign)
      automatch.score_categories = score_categories_assign(a,assign)
      if automatch.total_score > 20.00
        automatch.save
      end
    end

  end
end
