namespace :metrics do
  desc "Updates the metrics"

  task :update do
    require './lib/sidekiq/cloudwatch/metric_update'
    Sidekiq::Cloudwatch::MetricUpdate.new.run!
  end
end
