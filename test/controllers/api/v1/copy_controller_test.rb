require "test_helper"
require 'rake'

class Api::V1::CopyControllerTest < ActionDispatch::IntegrationTest

  def teardown
    Airtable::AirtableJsonManagementService.insert_json_records_on_a_file('./storage/airtable/test/', [{key: "intro.created_at",copy: "Intro created on {created_at, datetime}", "created_time":"2022-07-31T21:55:22.000Z"},{key:"intro.updated_at",copy:"Intro updated on {updated_at, datetime}", "created_time":"2022-07-31T21:55:22.000Z"}, {key: "time", copy: "It is {time, datetime}", "created_time":"2022-08-01T19:19:38.000Z" }, {key:"greeting",copy:"Hi {name}, welcome to {app}!", "created_time":"2022-07-31T21:55:22.000Z"}].to_json)
  end

  test "it should return all records from airtable-data.json file" do
    get '/api/v1/copy'
    assert_response :success
    assert_equal [{"key" =>"intro.created_at", "copy" =>"Intro created on {created_at, datetime}", "created_time" => "2022-07-31T21:55:22.000Z"}, {"key" =>"intro.updated_at", "copy" =>"Intro updated on {updated_at, datetime}", "created_time" => "2022-07-31T21:55:22.000Z"}, {"key" => "time", "copy" => "It is {time, datetime}", "created_time" => "2022-08-01T19:19:38.000Z"}, {"key" => "greeting", "copy" => "Hi {name}, welcome to {app}!", "created_time" => "2022-07-31T21:55:22.000Z"}], response.parsed_body['data']
    assert_equal 4, response.parsed_body['data'].count
  end

  test "it should filter per data all records from airtable-data.json file" do
    get '/api/v1/copy?since=1659380400'
    assert_response :success
    assert_equal [{"key" => "time", "copy" => "It is {time, datetime}", "created_time" => "2022-08-01T19:19:38.000Z"}], response.parsed_body['data']
    assert_equal 1, response.parsed_body['data'].count
  end

  test "it should return only one record with string replaced" do
    Airtable::AirtableJsonManagementService.insert_json_records_on_a_file('./storage/airtable/test/', [{key: "intro.created_at",copy: "Intro created on {created_at, datetime}", "created_time":"2022-07-31T21:55:22.000Z"},{key:"intro.updated_at",copy:"Intro updated on {updated_at, datetime}", "created_time":"2022-07-31T21:55:22.000Z"}, {key: "time", copy: "It is {time, datetime}", "created_time":"2022-08-01T19:19:38.000Z" },{key: "bye", copy: "Goodbye", "created_time":"2022-08-01T19:19:38.000Z" },  {key:"greeting",copy:"Hi {name}, welcome to {app}!", "created_time":"2022-07-31T21:55:22.000Z"}].to_json)
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

    get '/api/v1/copy/time?time=1604352707'
    assert_response :success
    assert_equal "It is Mon Nov 02 09:31:47PM", response.parsed_body['value']
    assert_equal 1, response.parsed_body.count

    get '/api/v1/copy/bye'
    assert_response :success
    assert_equal "Goodbye", response.parsed_body['value']
    assert_equal 1, response.parsed_body.count
  end

  test "it refresh airtable json records" do
    mock_request       = OpenStruct.new
    mock_request.table = []
    mock_service       = OpenStruct.new
    mock_service.get_all_table_records_json = [{key: "intro.created_at",copy: "Intro created on {created_at, datetime}"},{key:"intro.updated_at",copy:"Intro updated on {updated_at, datetime}"}, {key:"greeting",copy:"Hi {name}, welcome to {app}!"}].to_json
    Airtable::AirtableIntegrationService.stub :new, mock_service do
      HTTParty.stub :get, mock_request do
        get '/api/v1/copy/refresh'
        file_added   = File.read('./storage/airtable/test/airtable-data.json')
        file_decoded = ActiveSupport::JSON.decode(file_added)

        assert_response :success
        assert_equal "Copy refreshed", response.parsed_body['message']
        assert_equal 3, file_decoded.count
        assert_equal 'intro.created_at', file_decoded.first['key']
        assert_equal 'Intro created on {created_at, datetime}', file_decoded.first['copy']
        assert_equal 'intro.updated_at', file_decoded[1]['key']
        assert_equal 'Intro updated on {updated_at, datetime}', file_decoded[1]['copy']
        assert_equal 'greeting', file_decoded[2]['key']
        assert_equal 'Hi {name}, welcome to {app}!', file_decoded[2]['copy']
      end
    end
  end
end
