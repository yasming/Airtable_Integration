module ApplicationHelper
  def replace_string(record, values_to_be_replaced)
    values_to_be_replaced.map do |element|
      key            = element.first
      value          = element.last
      datetime_field = record["{#{key}, datetime}"]
      if datetime_field
        record["{#{key}, datetime}"] = Time.at(value.to_i).utc.strftime("%a %b %d %I:%M:%S%p")
      else
        record["{#{element.first}}"] = value
      end
    end
    record
  end
end
