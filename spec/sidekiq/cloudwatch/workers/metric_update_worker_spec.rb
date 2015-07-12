require 'spec_helper'
require './lib/sidekiq/cloudwatch/workers/metric_update_worker'

describe Sidekiq::Cloudwatch::MetricUpdateWorker do
  describe ".sidekiq_options" do
    let(:sidekiq_options) { described_class.sidekiq_options }

    it { expect(sidekiq_options["retry"]).to eq(false) }
    it { expect(sidekiq_options["queue"]).to eq(:sidekiq_cloudwatch_metric_update_queue) }
  end

  describe "#perform" do
    let(:metric_update) { double(Sidekiq::Cloudwatch::MetricUpdate) }

    before do
      allow(Sidekiq::Cloudwatch::MetricUpdate).to receive(:new).and_return(metric_update)
      allow(metric_update).to receive(:run!)
    end

    it { expect(metric_update).to receive(:run!); subject.perform }
  end
end
