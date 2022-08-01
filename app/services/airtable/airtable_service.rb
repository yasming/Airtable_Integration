class Airtable::AirtableService

  def initialize(api_key, project_id, table_name)
    airtable_client = Airtable::Client.new(api_key)
    @table          = airtable_client.table(project_id, table_name)
  end

  def show_all_table_records
    @table.records
  end

  def get_all_table_records_json
    @table.records&.map{|u| {key: u[:key], copy: u[:copy]}}.to_json
  end
end