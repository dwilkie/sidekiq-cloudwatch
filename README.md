# sidekiq-cloudwatch

AWS CloudWatch metrics for Sidekiq

## Usage Scenarios

* Autoscaling an Elastic Beanstalk Sidekiq environment based off of the queue size

## Configuration

Copy `.env` to `.env.production` and fill in `.env.production` with the real configuration values

## Testing in Development

```
bundle exec foreman run sidekiq-cloudwatch -e .env.production
```

Check the AWS console to see your custom metric

## Deployment

### Heroku

You can monitor your Sidekiq instances on AWS for free using Heroku

1. Fork the repo
2. Push your fork to Heroku
3. Setup your config vars with `heroku config:set`
4. Have a beer
