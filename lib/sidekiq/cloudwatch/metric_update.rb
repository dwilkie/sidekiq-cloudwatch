module Sidekiq
  module Cloudwatch
    class MetricUpdate
      require_relative 'client'
      require_relative 'workers/metric_update_worker'

      Dir[File.dirname(__FILE__) + "/metric/**/*.rb"].each { |f| require f }

      DEFAULT_METRIC_UPDATE_FREQUENCY_SECONDS = 60
      DEFAULT_METRIC_UPDATE_SCHEDULER_FREQUENCY_SECONDS = 600

      def schedule!
        (metric_update_scheduler_frequency_seconds / metric_update_frequency_seconds).times do |schedule|
          ::Sidekiq::Cloudwatch::MetricUpdateWorker.perform_at(Time.now + (schedule * metric_update_frequency_seconds))
        end
      end

      def run!
        ::Sidekiq::Cloudwatch::Metric::Base.descendants.each do |sidekiq_metric_class|
          client.metric = sidekiq_metric_class.new
          client.put
        end
      end

      private

      def metric_update_frequency_seconds
        (ENV["SIDEKIQ_CLOUDWATCH_METRIC_UPDATE_FREQUENCY_SECONDS"] || DEFAULT_METRIC_UPDATE_FREQUENCY_SECONDS).to_i
      end

      def metric_update_scheduler_frequency_seconds
        (ENV["SIDEKIQ_CLOUDWATCH_METRIC_UPDATE_SCHEDULER_FREQUENCY_SECONDS"] || DEFAULT_METRIC_UPDATE_SCHEDULER_FREQUENCY_SECONDS).to_i
      end

      def client
        @client ||= ::Sidekiq::Cloudwatch::Client.new
      end
    end
  end
end
