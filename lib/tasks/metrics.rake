namespace :metrics do
  require './lib/sidekiq/cloudwatch/metric_update'

  desc "Updates the metrics immediately"
  task :update do
    require './lib/sidekiq/cloudwatch/metric_update'
    Sidekiq::Cloudwatch::MetricUpdate.new.run!
  end

  desc "Schedules the metrics to be updated"
  task :schedule_update do
    Sidekiq::Cloudwatch::MetricUpdate.new.schedule!
  end
end
