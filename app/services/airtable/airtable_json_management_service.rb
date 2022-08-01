class Airtable::AirtableJsonManagementService
  def initialize
    @records = ActiveSupport::JSON.decode(File.read(Rails.configuration.x.folder + 'airtable-data.json'))
  end

  def return_all_records
    @records
  end
end