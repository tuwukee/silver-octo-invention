class SigninController < ApplicationController
  include ActionController::Cookies
  before_action :authorize_access_request!, only: [:destroy]

  def create
    user = User.find_by!(email: params[:email])
    if user.authenticate(params[:password])
      payload  = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login

      cookies[JWTSessions.access_cookie] = { value: tokens[:access], httponly: true }
      render json: { csrf: tokens[:csrf] }
    else
      not_authorized
    end
  end

  def destroy
    session = JWTSessions::Session.new
    session.flush_by_access_token(found_token)
    render json: :ok
  end
end
