require 'spec_helper'
require './lib/sidekiq/cloudwatch/client'
require './lib/sidekiq/cloudwatch/metric/base'
require 'rack/utils'

describe Sidekiq::Cloudwatch::Client do
  let(:metric_class) { Sidekiq::Cloudwatch::Metric::Base }
  let(:metric) { metric_class.new }

  subject { described_class.new(metric) }

  describe "#put" do
    let(:request_body) { Rack::Utils.parse_query(WebMock.requests.last.body) }

    before do
      VCR.use_cassette(:aws_cloudwatch_put_metric_data) { subject.put }
    end

    it "should send put_metric_data request to AWS" do
      expect(request_body["Action"]).to(
        eq("PutMetricData")
      )

      expect(request_body["Namespace"]).to(
        eq(described_class::DEFAULT_NAMESPACE)
      )

      expect(request_body["MetricData.member.1.MetricName"]).to(
        eq(described_class::DEFAULT_METRIC_NAME)
      )

      expect(request_body["MetricData.member.1.Dimensions.member.1.Name"]).to(
        eq(described_class::DEFAULT_DIMENSION_NAME)
      )

      expect(request_body["MetricData.member.1.Dimensions.member.1.Value"]).to(
        eq(described_class::DEFAULT_DIMENSION_VALUE)
      )

      expect(request_body["MetricData.member.1.Dimensions.member.1.Name"]).to(
        eq(described_class::DEFAULT_DIMENSION_NAME)
      )

      expect(request_body["MetricData.member.1.Timestamp"]).not_to be_empty

      expect(request_body["MetricData.member.1.Value"]).to(
        eq(metric_class::DEFAULT_VALUE)
      )

      expect(request_body["MetricData.member.1.Unit"]).to(
        eq(described_class::METRIC_UNITS[metric_class::DEFAULT_UNIT])
      )

      expect(request_body["MetricData.member.1.Dimensions.member.1.Name"]).to(
        eq(described_class::DEFAULT_DIMENSION_NAME)
      )
    end
  end
end
