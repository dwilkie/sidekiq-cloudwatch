module Sidekiq
  module Cloudwatch
    class Client
      require 'aws-sdk'

      DEFAULT_NAMESPACE = "Namespace"
      DEFAULT_METRIC_NAME = "MetricName"
      DEFAULT_DIMENSION_NAME = "AutoScalingGroupName"
      DEFAULT_DIMENSION_VALUE = "AutoScalingGroupName"

      METRIC_UNITS = {
        nil => "None",
        :count => "Count"
      }

      attr_accessor :metric

      def initialize(metric = nil)
        self.metric = metric
      end

      def put
        client.put_metric_data(put_metric_data_payload)
      end

      private

      def put_metric_data_payload
        {:namespace => namespace, :metric_data => metric_data}
      end

      def metric_data
        [
          {
            :metric_name => metric_name,
            :dimensions => dimensions,
            :timestamp => timestamp,
            :value => value,
            :unit => unit
          }
        ]
      end

      def namespace
        ENV["AWS_CLOUDWATCH_NAMESPACE"] || DEFAULT_NAMESPACE
      end

      def metric_name
        ENV["AWS_CLOUDWATCH_METRIC_NAME"] || DEFAULT_METRIC_NAME
      end

      def dimension_name
        ENV["AWS_CLOUDWATCH_DIMENSION_NAME"] || DEFAULT_DIMENSION_NAME
      end

      def dimension_value
        ENV["AWS_CLOUDWATCH_DIMENSION_VALUE"] || DEFAULT_DIMENSION_VALUE
      end

      def dimensions
        (ENV["AWS_CLOUDWATCH_DIMENSIONS"] && JSON.parse(ENV["AWS_CLOUDWATCH_DIMENSIONS"])) || default_dimensions
      end

      def default_dimensions
        [{:name => dimension_name, :value => dimension_value}]
      end

      def timestamp
        Time.now
      end

      def value
        metric.value
      end

      def unit
        METRIC_UNITS[metric.unit]
      end

      def client
        @client ||= ::Aws::CloudWatch::Client.new
      end
    end
  end
end
