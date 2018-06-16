class SignupController < ApplicationController
  include ActionController::Cookies

  def create
    user = User.new(user_params)
    if user.save
      payload  = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login

      cookies[JWTSessions.access_cookie] = { value: tokens[:access], httponly: true }
      render json: { csrf: tokens[:csrf] }
    else
      not_authorized
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
