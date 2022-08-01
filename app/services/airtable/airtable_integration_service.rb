class Airtable::AirtableIntegrationService
  def initialize(api_key, project_id, table_name)
    @table = HTTParty.get(ENV['AIRTABLE_INTEGRATION_URL']+project_id+'/'+table_name, :headers => {Authorization: "Bearer #{api_key}"})
  end

  def get_all_table_records_json
    @table['records']&.map{|record| {key: record['fields']['Key'], copy: record['fields']['Copy'], created_time: record['createdTime']}}.to_json
  end
end