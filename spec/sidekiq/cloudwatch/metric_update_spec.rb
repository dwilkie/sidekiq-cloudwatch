require 'spec_helper'
require 'sidekiq/testing'
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

  describe "#schedule!" do
    let(:scheduled_jobs) { ::Sidekiq::Cloudwatch::MetricUpdateWorker.jobs }
    let(:scheduled_job) { scheduled_jobs.last }

    before do
      Sidekiq::Testing.fake!
      Sidekiq::Worker.clear_all
      subject.schedule!
    end

    it { expect(scheduled_jobs.size).to eq(described_class::DEFAULT_METRIC_UPDATE_SCHEDULER_FREQUENCY_SECONDS / described_class::DEFAULT_METRIC_UPDATE_FREQUENCY_SECONDS) }
    it { expect(scheduled_job["at"]).not_to eq(nil) }
    it { expect(scheduled_job["class"]).to eq("Sidekiq::Cloudwatch::MetricUpdateWorker") }
  end
end
