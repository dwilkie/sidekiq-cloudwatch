require 'webmock/rspec'
WebMock.disable_net_connect!

module LastRequest
  def clear_requests!
    @requests = nil
  end

  def requests
    @requests ||= []
  end

  def last_request=(request_signature)
    requests << request_signature
    request_signature
  end
end

WebMock.extend(LastRequest)
WebMock.after_request do |request_signature, response|
  WebMock.last_request = request_signature
end

RSpec.configure do |config|
  config.before do
    WebMock.clear_requests!
  end
end
