require 'test_helper'

class MarketControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get market_index_url
    assert_response :success
  end

end
