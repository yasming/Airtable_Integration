require "test_helper"

class Api::V1::CopyControllerTest < ActionDispatch::IntegrationTest
  test "it should return all records from airtable-data.json file" do
    get '/api/v1/copy'
    assert_response :success
    assert_equal [{"key" =>"intro.created_at", "copy" =>"Intro created on {created_at, datetime}"}, {"key" =>"intro.updated_at", "copy" =>"Intro updated on {updated_at, datetime}"}, {"key" =>"greeting", "copy" =>"Hi {name}, welcome to {app}!"}], response.parsed_body['data']
    assert_equal 3, response.parsed_body['data'].count
  end

  test "it should return only one record with string replaced" do
    get '/api/v1/copy/greeting?name=John&app=Bridge'
    assert_response :success
    assert_equal "Hi John, welcome to Bridge!", response.parsed_body['value']
    assert_equal 1, response.parsed_body.count

    get '/api/v1/copy/intro.created_at?created_at=1603814215'
    assert_response :success
    assert_equal "Intro created on Tue Oct 27 03:56:55PM", response.parsed_body['value']
    assert_equal 1, response.parsed_body.count

    get '/api/v1/copy/intro.updated_at?updated_at=1604063144'
    assert_response :success
    assert_equal "Intro updated on Fri Oct 30 01:05:44PM", response.parsed_body['value']
    assert_equal 1, response.parsed_body.count
  end
end
