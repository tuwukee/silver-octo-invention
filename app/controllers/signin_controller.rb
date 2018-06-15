class SigninController < ApplicationController
  include ActionController::Cookies

  def create
    user = User.find_by!(email: params[:email])
    if user.authenticate(params[:password])
      payload  = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login

      cookies[JWTSessions.access_cookie] = tokens[:access]
      render json: { csrf: tokens[:csrf] }
    else
      not_authorized
    end
  end
end
