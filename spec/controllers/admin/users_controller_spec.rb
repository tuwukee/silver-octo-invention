require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:manager) { create(:user, role: :manager) }
  let!(:admin) { create(:user, role: :admin) }

  describe 'GET #index' do
    it 'allows admin to receive users list' do
      sign_in_as(admin)
      get :index
      expect(response).to be_successful
      expect(response_json.size).to eq 3
    end

    it 'allows manager to receive users list' do
      sign_in_as(manager)
      get :index
      expect(response).to be_successful
      expect(response_json.size).to eq 3
    end

    it 'does not allow regular user to receive users list' do
      sign_in_as(user)
      get :index
      expect(response).to have_http_status(403)
    end
  end

  describe 'GET #show' do
    it 'allows admin to get a user' do
      sign_in_as(admin)
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end

    it 'allows manager to get a user' do
      sign_in_as(manager)
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end

    it 'does not allow regular user to get a user' do
      sign_in_as(user)
      get :show, params: { id: user.id }
      expect(response).to have_http_status(403)
    end
  end

  describe 'PATCH #update' do
    it 'allows admin to update a user' do
      sign_in_as(admin)
      patch :update, params: { id: user.id, user: { role: :manager } }
      expect(response).to be_successful
      expect(user.reload.role).to eq 'manager'
    end

    it 'does not allow manager to update a user' do
      sign_in_as(manager)
      patch :update, params: { id: user.id, user: { role: :manager } }
      expect(response).to have_http_status(403)
    end

    it 'does not allow user to update a user' do
      sign_in_as(user)
      patch :update, params: { id: user.id, user: { role: :manager } }
      expect(response).to have_http_status(403)
    end

    it 'does not allow admin to update their own role' do
      sign_in_as(admin)
      patch :update, params: { id: admin.id, user: { role: :manager } }
      expect(response).to have_http_status(400)
    end
  end
end
