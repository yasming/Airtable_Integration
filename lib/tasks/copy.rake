namespace :copy do
  desc 'import base from airtable to local json'
  task :copy_from_airtable_to_json, [:folder] => [:environment] do |t,args|
    begin
      folder = args[:folder] ? args[:folder] : './storage/airtable/'
      unless File.directory?(folder)
        FileUtils.mkdir_p(folder)
      end
      airtable_service = Airtable::AirtableService.new(ENV["AIRTABLE_API_KEY"], ENV["PROJECT_ID"], ENV["TABLE_NAME"])
      File.write(folder+'airtable-data.json', airtable_service.get_all_table_records_json)
      puts 'airtable records added to json'
    rescue => e
      puts e.message
    end
  end
end