class Airtable::AirtableJsonManagementService
  attr_reader :folder
  def initialize
    @folder  = Rails.configuration.x.folder
    @records = ActiveSupport::JSON.decode(File.read(@folder + 'airtable-data.json'))
  end

  def return_all_records
    @records
  end

  def get_associated_record_to_key(key)
    @records.select{|record| record['key'] == key}&.first
  end

  def self.insert_json_records_on_a_file(folder, records)
    File.write(folder+'airtable-data.json', records)
  end
end