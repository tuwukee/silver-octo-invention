class Admin::UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_user, only: [:show, :update]
  ROLES = %w[admin manager].freeze

  def index
    @users = User.all

    render json: @users.as_json(only: [:id, :email, :role])
  end

  def show
    render json: @user.as_json(only: [:id, :email, :role])
  end

  def update
    @user.update!(user_params)
    render json: @user.as_json(only: [:id, :email, :role])
  end

  def token_claims
    {
      aud: ROLES,
      verify_aud: true
    }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role)
  end
end
