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
    mock_service.get_all_table_records_json = [{:key=>"intro.created_at", :copy=>"Intro created on {created_at, datetime}"}].to_json

    Airtable::AirtableService.stub :new, mock_service do
      Airtable::Client.stub :new, mock_request do
        Rake::Task["copy:copy_from_airtable_to_json"].invoke('./storage/airtable/test/')
        file_added   = File.read('./storage/airtable/test/airtable-data.json')
        file_decoded = ActiveSupport::JSON.decode(file_added)
        assert_equal 1, file_decoded.count
        assert_equal 'intro.created_at', file_decoded.first['key']
        assert_equal 'Intro created on {created_at, datetime}', file_decoded.first['copy']
      end
    end
  end
end