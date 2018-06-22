require 'rails_helper'

RSpec.describe TodosController, type: :controller do
  let(:user) { create(:user) }

  let(:valid_attributes) {
    { title: 'new title' }
  }

  let(:invalid_attributes) {
    { title: nil }
  }

  before { sign_in_as(user) }

  describe 'GET #index' do
    let!(:todo) { create(:todo, user: user) }

    it 'returns a success response' do
      get :index
      expect(response).to be_successful
      expect(response_json.size).to eq 1
      expect(response_json.first['id']).to eq todo.id
    end

    # usually there's no need to test this kind of stuff, it's here for the presentation purpose
    it 'unauth without cookie' do
      request.cookies[JWTSessions.access_cookie] = nil
      get :index
      expect(response).to have_http_status(401)
    end
  end

  describe 'GET #show' do
    let!(:todo) { create(:todo, user: user) }
    before { sign_in_as(user) }

    it 'returns a success response' do
      get :show, params: { id: todo.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do

    context 'with valid params' do
      it 'creates a new Todo' do
        expect {
          post :create, params: { todo: valid_attributes }
        }.to change(Todo, :count).by(1)
      end

      it 'renders a JSON response with the new todo' do
        post :create, params: { todo: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(todo_url(Todo.last))
      end

      it 'unauth without CSRF' do
        request.headers[JWTSessions.csrf_header] = nil
        post :create, params: { todo: valid_attributes }
        expect(response).to have_http_status(401)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new todo' do
        post :create, params: { todo: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    let!(:todo) { create(:todo, user: user) }

    context 'with valid params' do
      let(:new_attributes) {
        { title: 'Super secret title' }
      }

      it 'updates the requested todo' do
        put :update, params: { id: todo.id, todo: new_attributes }
        todo.reload
        expect(todo.title).to eq new_attributes[:title]
      end

      it 'renders a JSON response with the todo' do
        put :update, params: { id: todo.to_param, todo: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the todo' do
        put :update, params: { id: todo.to_param, todo: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:todo) { create(:todo, user: user) }

    it 'destroys the requested todo' do
      expect {
        delete :destroy, params: { id: todo.id }
      }.to change(Todo, :count).by(-1)
    end
  end
end
