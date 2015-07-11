module Sidekiq
  module Cloudwatch
    class MetricUpdate
      require_relative "client"

      Dir[File.dirname(__FILE__) + "/metric/**/*.rb"].each { |f| require f }

      def run!
        Sidekiq::Cloudwatch::Metric::Base.descendants.each do |sidekiq_metric_class|
          client.metric = sidekiq_metric_class.new
          client.put
        end
      end

      private

      def client
        @client ||= ::Sidekiq::Cloudwatch::Client.new
      end
    end
  end
end
