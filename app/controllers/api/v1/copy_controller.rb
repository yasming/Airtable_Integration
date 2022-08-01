class Api::V1::CopyController < ApplicationController
  include ApplicationHelper
  before_action :set_airtable_json_management_service, only: [:index, :show, :refresh]
  def index
    render json: {data: @airtable_json_management_service.return_all_records}
  end

  def show
    begin
      record                 = @airtable_json_management_service.get_associated_record_to_key(params[:key])
      string_record_replaced = replace_string(record["copy"], request.query_parameters)
      render json: {value: string_record_replaced}
    rescue => e
      render json: {error: e.message}
    end
  end

  def refresh
    airtable_service = Airtable::AirtableIntegrationService.new(ENV["AIRTABLE_API_KEY"], ENV["PROJECT_ID"], ENV["TABLE_NAME"])
    Airtable::AirtableJsonManagementService::insert_json_records_on_a_file(@airtable_json_management_service.folder, airtable_service.get_all_table_records_json)
    render json: {message: 'Copy refreshed'}
  end

  private

  def set_airtable_json_management_service
    @airtable_json_management_service = Airtable::AirtableJsonManagementService.new
  end
end