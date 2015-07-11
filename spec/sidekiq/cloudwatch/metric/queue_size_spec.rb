require 'spec_helper'
require './lib/sidekiq/cloudwatch/metric/queue_size'

describe Sidekiq::Cloudwatch::Metric::QueueSize do
  describe "#value" do
    it { expect(subject.value).to be_a(Integer) }
  end

  describe "#unit" do
    it { expect(subject.unit).to eq(described_class::UNIT) }
  end
end
