class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
  rescue_from JWTSessions::Errors::ClaimsVerification, with: :forbidden
  rescue_from ResetPasswordError, with: :not_authorized

  private

  def current_user
    @current_user ||= User.find(payload['user_id'])
  end

  def bad_request
    render json: { error: 'Bad request' }, status: :bad_request
  end

  def forbidden
    render json: { error: 'Forbidden' }, status: :forbidden
  end

  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end

  def not_found
    render json: { error: 'Not found' }, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: { error: exception.record.errors.full_messages.join(' ') }, status: :unprocessable_entity
  end
end
