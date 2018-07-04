require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let(:user) { create(:user) }

  describe "POST #create" do
    it do
      expect(UserMailer).to receive(:reset_password).once.and_return(double(deliver_now: true))
      post :create, params: { email: user.email }
      expect(response).to be_successful
    end

    it do
      expect(UserMailer).to_not receive(:reset_password)
      post :create, params: { email: 'non@existent.com' }
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it do
      user.generate_password_token!
      get :edit, params: { token: user.reset_password_token }
      expect(response).to be_successful
    end

    it 'returns unauthorized for expired tokens' do
      user.generate_password_token!
      user.update({ reset_password_token_expires_at: 2.days.ago })
      get :edit, params: { token: user.reset_password_token }
      expect(response).to have_http_status(401)
    end

    it 'returns unauthorized for invalid expirations' do
      user.generate_password_token!
      user.update({ reset_password_token_expires_at: nil })
      get :edit, params: { token: user.reset_password_token }
      expect(response).to have_http_status(401)
    end

    it 'returns unauthorized for invalid params' do
      user.generate_password_token!
      get :edit, params: { token: 1 }
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH #update" do
    let(:new_password) { 'new_password' }
    it do
      user.generate_password_token!
      patch :update, params: { token: user.reset_password_token, password: new_password, password_confirmation: new_password }
      expect(response).to be_successful
    end

    it 'returns 422 if passwords do not match' do
      user.generate_password_token!
      patch :update, params: { token: user.reset_password_token, password: new_password, password_confirmation: 1 }
      expect(response).to have_http_status(422)
    end

    it 'returns 400 if param is missing' do
      user.generate_password_token!
      patch :update, params: { token: user.reset_password_token, password: new_password }
      expect(response).to have_http_status(400)
    end
  end
end
