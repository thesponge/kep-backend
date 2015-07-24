class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::ImplicitRender
  include ActionController::StrongParameters
  include ActionController::HttpAuthentication::Token
  include PublicActivity::StoreController

  before_action :authenticate_user_from_token!
  before_action :set_default_response_format

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  skip_before_filter :verify_authenticity_token

  def set_default_response_format
    request.format = :json
  end

  #Devise methods overwrites

  #Identifies current user by the token from the request
  def current_user
    @current_user ||= User.find_by(authentication_token: token_and_options(request))
  end
  hide_action :current_user

  def record_not_found(error)
    render :json => {:error => error.message}, :status => :not_found
  end

  private

  #Prevents unauthorized users from making user  specific actions i.e. edit & friends
  def authenticate_with_token!
    render json: { errors: 'Not authenticated'},
      status: :unauthorized unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user_from_token!
    authenticate_with_http_token do |token, options|
      user_email = options[:email].presence
      user = user_email && User.find_by_email(user_email)

      if user && Devise.secure_compare(user.authentication_token, token)
        sign_in user, store: false
      else
        render json: { message: 'Invalid authorization.' }, status: 400
      end
    end
  end


end
