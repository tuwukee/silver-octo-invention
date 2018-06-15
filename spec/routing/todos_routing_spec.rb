require "rails_helper"

RSpec.describe TodosController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/todos").to route_to("todos#index")
    end


    it "routes to #show" do
      expect(:get => "/todos/1").to route_to("todos#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/todos").to route_to("todos#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/todos/1").to route_to("todos#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/todos/1").to route_to("todos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/todos/1").to route_to("todos#destroy", :id => "1")
    end

  end
end
