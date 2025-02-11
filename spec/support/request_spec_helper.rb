module RequestSpecHelper
  def json_response
    @json_response ||= JSON.parse(response.body, object_class: OpenStruct)
  end
end

RSpec.configure do |config|
  config.include RequestSpecHelper, type: :request
end