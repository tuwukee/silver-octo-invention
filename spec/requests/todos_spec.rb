require 'rails_helper'

RSpec.describe "Todos", type: :request do
  describe "GET /todos" do
    xit "works! (now write some real specs)" do
      get todos_path
      expect(response).to have_http_status(200)
    end
  end
end
