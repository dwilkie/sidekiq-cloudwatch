require 'sidekiq'
require 'sidekiq/api'

module Sidekiq
  module Cloudwatch
    module Metric
      class Base
        DEFAULT_VALUE = "0.0"
        DEFAULT_UNIT = nil

        def self.descendants
          ObjectSpace.each_object(Class).select { |klass| klass < self }
        end

        def value
          DEFAULT_VALUE
        end

        def unit
          DEFAULT_UNIT
        end

        private

        def stats
          @stats ||= ::Sidekiq::Stats.new
        end
      end
    end
  end
end
