class Api::V1::CopyController < ApplicationController
  before_action :set_airtable_json_management_service, only: [:index]

  def index
    render json: {data: @airtable_json_management_service.return_all_records}
  end

  private

  def set_airtable_json_management_service
    @airtable_json_management_service = Airtable::AirtableJsonManagementService.new
  end
end