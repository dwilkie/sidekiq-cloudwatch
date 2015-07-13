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

You can monitor your Sidekiq instances on AWS for free using Heroku Scheduler

1. Fork the repo
2. Push your fork to Heroku
3. Setup your config vars with `heroku config:set`
4. Use Heroku Scheduler to trigger `rake metrics:update` or `rake metrics:schedule_update` every 10 minutes
5. Have a beer

Notes:

To get finer granularity on Heroku you can run a job every minute with Heroku Scheduler by creating 10 jobs spaced 1 minute apart. `POST` to scheduler using the following command:

```
curl 'https://scheduler.heroku.com/jobs' --data 'command=rake+metrics%3Aupdate&dyno_size=11&every=10&at=9'
```

`at` is the minute you want to start the job and takes the values `0` to `9`. You'll also need to post your cookie. To get the full `curl` command I used Chrome Develper Tools and captured a request.

Scheduling and update with `rake metrics:schedule_update` also works but the worker process will sleep on a free Heroku dyno.

## Autoscaling with Elastic Beanstalk

Elastic Beanstalk doesn't let you configure alarms for custom metrics for autoscaling out of the box. However you can manually change the Autoscaling group to add custom Scaling Policies.

1. Configure an Elastic Beanstalk Environment with Autoscaling
2. Select CPU Utilization as your Trigger measurement with sensible defaults e.g. Upper threshold: `90`, Lower threshold `45`
3. After the environment has been created it will create a new Autoscaling Group. You can find it in the AWS Web Console under `EC2 -> Autoscaling -> Autoscaling Groups`
4. Note the name of the autoscaling group and configure it in the Heroku config. e.g. `heroku config:set AWS_CLOUDWATCH_DIMENSION_VALUE=<auto-scaling-group-name>`
5. Set up two new CloudWatch alarms for your Sidekiq metric in the AWS Web Consule under `CloudWatch -> Custom Metrics`. One should be for `sidekiq-worker-overload` and the other should be for `sidekiq-worker-underload`
6. Back in the AWS Web Console under `EC2 -> Autoscaling -> Autoscaling Groups -> Scaling Policies` add two new policies. One for `aws-eb-autoscale-up` and the other for `aws-eb-autoscale-down`. Select the appropriate alarm created in step 5 for each policy.
7. Remove the autogenerated scaling policies created by Elastic Beanstalk.
8. Optionally remove the autogenerated alarms created by Elastic Beanstalk or configure them to send a notification.

Note if you ever rebuild or terminate your environment, Elastic Beanstalk will create a new autoscaling group and CloudWatch put the CloudWatch alarms in it. You'll need to repeat steps. 3-8 above.
