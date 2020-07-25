require 'test_helper'

module Season
  class SeasonsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get seasons_index_url
      assert_response :success
    end

  end
end
