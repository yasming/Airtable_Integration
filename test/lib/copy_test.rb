require 'test_helper'
require 'rake'

class CopyTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks
  end

  test "it should get records from airtable and create a new json record file" do
    mock_request       = OpenStruct.new
    mock_request.table = []
    mock_service       = OpenStruct.new
    mock_service.get_all_table_records_json = [{key: "intro.created_at",copy: "Intro created on {created_at, datetime}", "created_time":"2022-07-31T21:55:22.000Z"},{key:"intro.updated_at",copy:"Intro updated on {updated_at, datetime}", "created_time":"2022-07-31T21:55:22.000Z"}, {key: "time", copy: "It is {time, datetime}", "created_time":"2022-07-31T21:55:22.000Z" }, {key:"greeting",copy:"Hi {name}, welcome to {app}!", "created_time":"2022-07-31T21:55:22.000Z"}].to_json

    Airtable::AirtableIntegrationService.stub :new, mock_service do
      Airtable::Client.stub :new, mock_request do
        FileUtils.rm_rf("./storage/airtable/test/") if Dir.exist?("./storage/airtable/test/")
        Rake::Task["copy:copy_from_airtable_to_json"].invoke('./storage/airtable/test/')
        file_added   = File.read('./storage/airtable/test/airtable-data.json')
        file_decoded = ActiveSupport::JSON.decode(file_added)
        assert_equal 4, file_decoded.count
        assert_equal 'intro.created_at', file_decoded.first['key']
        assert_equal 'Intro created on {created_at, datetime}', file_decoded.first['copy']
        assert_equal 'intro.updated_at', file_decoded[1]['key']
        assert_equal 'Intro updated on {updated_at, datetime}', file_decoded[1]['copy']
        assert_equal 'time', file_decoded[2]['key']
        assert_equal 'It is {time, datetime}', file_decoded[2]['copy']
        assert_equal 'greeting', file_decoded[3]['key']
        assert_equal 'Hi {name}, welcome to {app}!', file_decoded[3]['copy']
      end
    end
  end
end