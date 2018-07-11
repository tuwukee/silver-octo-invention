class Admin::UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_user, only: [:show, :update]
  VIEW_ROLES = %w[admin manager].freeze
  EDIT_ROLES = %w[admin].freeze

  def index
    @users = User.all

    render json: @users
  end

  def show
    render json: @user
  end

  def update
    if current_user.id != @user.id
      @user.update!(user_params)
      JWTSessions::Session.new(namespace: "user_#{@user.id}").flush_namespaced_access_tokens
      render json: @user
    else
      render json: { error: 'Admin cannot modify their own role' }, status: :bad_request
    end
  end

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  private

  def allowed_aud
    action_name == 'update' ? EDIT_ROLES : VIEW_ROLES
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role)
  end
end
