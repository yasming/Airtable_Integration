require "test_helper"

class Api::V1::CopyControllerTest < ActionDispatch::IntegrationTest
  test "it should return all records from airtable-data.json file" do
    get '/api/v1/copy'
    assert_response :success
    assert_equal [{"key" =>"intro.created_at", "copy" =>"Intro created on {created_at, datetime}"}], response.parsed_body['data']
  end
end
