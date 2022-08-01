class Airtable::AirtableJsonManagementService
  def initialize
    @records = ActiveSupport::JSON.decode(File.read(Rails.configuration.x.folder + 'airtable-data.json'))
  end

  def return_all_records
    @records
  end

  def get_associated_record_to_key(key)
    @records.select{|record| record['key'] == key}&.first
  end
end