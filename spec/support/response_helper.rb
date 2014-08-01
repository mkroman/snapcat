module ResponseHelper
  extend self

  def hash_for(response_name, status = :success)
    raw_response = json_for(response_name, status)
    JSON.parse(raw_response, { symbolize_names: true })
  end

  def json_for(response_name, status = :success)
    File.open(
      "#{SPEC_ROOT}/support/responses/#{response_name}_#{status}.json",
      'rb'
    ).read
  end
end
