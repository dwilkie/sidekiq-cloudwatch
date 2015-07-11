require_relative 'base'

module Sidekiq
  module Cloudwatch
    module Metric
      class QueueSize < ::Sidekiq::Cloudwatch::Metric::Base
        UNIT = :count

        def value
          stats.queues.values.inject(0, :+)
        end

        def unit
          UNIT
        end
      end
    end
  end
end
