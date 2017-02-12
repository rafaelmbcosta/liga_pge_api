require "rails_helper"

RSpec.describe "Season management", :type => :request do

  before do
    @seasons = FactoryGirl.create_list(:season, 3)
  end

  it "get all seaons" do
    get "/seasons"
    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(200)
    expect(response.body).to eq(@seasons.to_json)
  end

  it "creates a new Season" do
    season = FactoryGirl.build(:season)
    post "/seasons", params: { season: season.attributes }
    expect(response).to have_http_status(:created)
  end

  it "fails to create a Season" do
    season = FactoryGirl.build(:season, year: nil)
    post "/seasons", params: { season: season.attributes }
    expect(response).not_to have_http_status(:missing)
  end
end
