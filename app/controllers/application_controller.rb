class ApplicationController < ActionController::API
  include AuthenticationHelper
  
  before_action :authenticate_user!
  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_response
  
  private
  
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = decode_token(token)
    
    if decoded_token
      @current_user = User.find(decoded_token['user_id'])
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
  
  def current_user
    @current_user
  end
  
  def not_found
    render json: { error: 'Not found' }, status: :not_found
  end
  
  def unprocessable_entity_response(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end

