require 'rails_helper'

RSpec.describe SigninController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:password) { 'password' }
    let(:user_params) { { email: user.email, password: password } }

    it 'returns http success' do
      post :create, params: user_params
      expect(response).to be_successful
      expect(response_json.keys).to eq ['csrf']
      expect(response.cookies[JWTSessions.access_cookie]).to be_present
    end

    it 'returns unauthorized for invalid params' do
      post :create, params: { email: user.email, password: 'incorrect' }
      expect(response).to have_http_status(401)
    end
  end

  describe 'logout DELETE #destroy' do
    context 'failure' do
      it 'returns unauthorized http status' do
        delete :destroy
        expect(response).to have_http_status(401)
      end
    end
    context 'success' do
      it 'returns http success with valid tokens' do
        payload = { user_id: user.id }

        session = JWTSessions::Session.new(
          payload: payload,
          refresh_by_access_allowed: true,
          namespace: "user_#{user.id}"
        )
                                            
        tokens = session.login
        request.cookies[JWTSessions.access_cookie] = tokens[:access]
        request.headers[JWTSessions.csrf_header] = tokens[:csrf]

        delete :destroy
        expect(response).to have_http_status(200)
        expect(response_json).to eq('ok')
      end
    end
  end
end
