require "rails_helper"

RSpec.describe MonthActivitiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/month_activities").to route_to("month_activities#index")
    end


    it "routes to #show" do
      expect(:get => "/month_activities/1").to route_to("month_activities#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/month_activities").to route_to("month_activities#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/month_activities/1").to route_to("month_activities#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/month_activities/1").to route_to("month_activities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/month_activities/1").to route_to("month_activities#destroy", :id => "1")
    end

  end
end
