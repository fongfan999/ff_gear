require 'test_helper'

class MainControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get main_about_url
    assert_response :success
  end

  test "should get search" do
    get main_search_url
    assert_response :success
  end

end
