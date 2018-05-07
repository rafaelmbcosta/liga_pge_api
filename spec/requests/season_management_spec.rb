require "rails_helper"

RSpec.describe "Season management", :type => :request do

  before do
    @seasons = FactoryBot.create_list(:v1_season, 3)
  end

  it "get all seaons" do
    get api_v1_seasons_url
    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(200)
    expect(response.body).to eq(@seasons.to_json)
  end

  it "fails to create a Season" do
    season = FactoryBot.build(:v1_season, year: nil)
    post api_v1_seasons_url, params: { season: season.attributes }
    expect(response).not_to have_http_status(:missing)
  end
end
