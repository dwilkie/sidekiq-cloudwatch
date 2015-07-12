module Sidekiq
  module Cloudwatch
    class MetricUpdateWorker
      require 'sidekiq'
      require_relative '../metric_update'

      include ::Sidekiq::Worker
      sidekiq_options(:queue => :sidekiq_cloudwatch_metric_update_queue, :retry => false)

      def perform
        ::Sidekiq::Cloudwatch::MetricUpdate.new.run!
      end
    end
  end
end
