# sidekiq-cloudwatch

[![Build Status](https://travis-ci.org/dwilkie/sidekiq-cloudwatch.svg?branch=master)](https://travis-ci.org/dwilkie/sidekiq-cloudwatch)

AWS CloudWatch metrics for Sidekiq

## Usage Scenarios

* Autoscaling an Elastic Beanstalk Sidekiq environment based off of the queue size

## Configuration

Copy `.env` to `.env.production` and fill in `.env.production` with the real configuration values

## Testing in Development

```
bundle exec foreman run -e .env.production rake metrics:update
```

Check the AWS console to see your custom metric

## Deployment

### Heroku

You can monitor your Sidekiq instances on AWS for free using Heroku

1. Fork the repo
2. Push your fork to Heroku
3. Setup your config vars with `heroku config:set`
4. Use Heroku Scheduler to trigger `rake metrics:update` every 10 minutes
5. Have a beer

Need to update more frequently than once every 10 minutes? See [Issue #1](https://github.com/dwilkie/sidekiq-cloudwatch/issues/1)
