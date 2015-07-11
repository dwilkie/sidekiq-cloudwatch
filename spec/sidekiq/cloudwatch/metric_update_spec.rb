require 'spec_helper'
require './lib/sidekiq/cloudwatch/metric_update'

describe Sidekiq::Cloudwatch::MetricUpdate do
  describe "#run!" do
    let(:request) { WebMock.requests }

    before do
      VCR.use_cassette(:aws_cloudwatch_put_metric_data) do
        subject.run!
      end
    end

    it { expect(WebMock.requests.size).to eq(Sidekiq::Cloudwatch::Metric::Base.descendants.count) }
  end
end
