require 'rails_helper'

RSpec.describe "MonthActivities", type: :request do
  describe "GET /month_activities" do
    it "works! (now write some real specs)" do
      get month_activities_path
      expect(response).to have_http_status(200)
    end
  end
end
