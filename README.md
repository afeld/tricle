# Tricle [![Build Status](https://travis-ci.org/afeld/tricle.png?branch=master)](https://travis-ci.org/afeld/tricle) [![Code Climate](https://codeclimate.com/github/afeld/tricle.png)](https://codeclimate.com/github/afeld/tricle)

Automated metrics reporting via email.  It's datastore-agnostic, so you can query SQL, MongoDB, external APIs, etc. to generate the stats you need.  See [here](https://github.com/afeld/tricle-afeld) for an example implementation ([live demo](http://tricle.afeld.me/weekly_metrics)).

![screenshot](screenshot.png)

## Installation

### Gem

This gem can be used within an existing project (e.g. a Rails app), or standalone.

```ruby
# Gemfile
gem 'tricle', '~> 0.2.0'

# Rakefile
require 'tricle/tasks'

# your/config/file.rb
# unless you already have ActionMailer set up
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  # ...
}
```

See [the ActionMailer guide](http://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration) for configuration details.  Finally, execute:

```bash
bundle
```

## Usage

### Metrics

For each metric you want to report, create a new subclass of `Tricle::Metric` that implements `#size_for_range` and `#total`:

```ruby
class MyMetric < Tricle::Metric

  # Retrieve the value of this metric for the provided time period. Generally
  # this will be the count/value added/removed. Not necessary if #items_for_range
  # is defined.
  #
  # @param start_at [Time]
  # @param end_at [Time] non-inclusive
  # @return [Fixnum]
  def size_for_range(start_at, end_at)
    # ...
  end

  # Optional: Retrieve the cumulative value for this metric. If not defined,
  # the total won't be displayed in the mailer.
  #
  # @return [Fixnum] the grand total
  def total
    # ...
  end

  # Optional: Only necessary if using `list` for this Metric within your Mailer.
  #
  # @param start_at [Time]
  # @param end_at [Time] non-inclusive
  # @return [Enumerator]
  def items_for_range(start_at, end_at)
    # ...
  end

end
```

ActiveRecord example:

```ruby
# app/metrics/new_users.rb
class NewUsers < Tricle::Metric

  def size_for_range(start_at, end_at)
    self.items_for_range(start_at, end_at).count
  end

  def total
    self.users.count
  end

  def items_for_range(start_at, end_at)
    self.users.where('created_at >= ? AND created_at < ?', start_at, end_at)
  end


  private

  # You can add whatever helper methods in that class that you need.
  def users
    # non-deleted Users
    User.where(deleted_at: nil)
  end

end
```

If you would like finer-grain optimization, the methods included from the [`Aggregation`](lib/tricle/arregation.rb) mixin can be overridden.

#### "Lower is better" metrics

By default, Tricle highlights numbers that increased in green, and those that decreased in red. If you have a metric where a *lower* number is considered better, you'll want to override the `#better` method so Tricle highlights your cells properly:

```ruby
class LowerIsBetterMetric < Tricle::Metric
  def better
    :lower
  end

  ...
end
```

You can also return `:none`, and none of your cells for that metric will be highlighted green or red.

### Mailers

Mailers specify how a particular set of Metrics should be sent.  You can define one or multiple, to send different metrics to different groups of people.

```ruby
class MyMailer < Tricle::Mailer

  # accepts the same options as ActionMailer... see "Default Hash" at
  # http://rubydoc.info/gems/actionmailer/ActionMailer/Base
  default(
    # ...
  )

  metric MyMetric1
  metric MyMetric2
  # ...

  # optional: metrics can be grouped
  group "Group 1 Name" do
    metric MyMetric3
    # ...
  end
  group "Group 2 Name" do
    metric MyMetric4
    # ...
  end

  # optional: list the items for the specified Metric
  list MyMetric2 do |item|
    # return the HTML string for each particular item
  end
  # ...

end
```

e.g.

```ruby
# app/mailers/weekly_insights.rb
class WeeklyInsights < Tricle::Mailer

  default(
    to: ['theteam@mycompany.com', 'theboss@mycompany.com'],
    from: 'noreply@mycompany.com'
  )

  metric NewUsers

  list NewUsers do |user|
    <<-MARKUP
      <h3>#{user.name}</h3>
      <div>#{user.location}</div>
      <a href="mailto:#{user.email}>#{user.email}</a>
    MARKUP
  end

end
```

The subject line will be based on the Mailer class name.

### Previewing

Since you'd probably like to preview your mailers before sending them, set up the `Tricle::MailPreview` Rack app (which uses [MailView](https://github.com/37signals/mail_view)).

#### Within a Rails app

```ruby
# config/initializers/tricle.rb
require 'tricle/mail_preview'

# config/routes.rb
if Rails.env.development?
  mount MailPreview => 'mail_view'
end
```

##### With sparklines as inline attachments

Unfortunately, the sparkline graphs (if displayed as inline attachments, as in the default) cannot be displayed by the preview pages powered by mailview, but they can be by email clients and by [mailcatcher](http://rubygems.org/gems/mailcatcher). To test send an email:
* `gem install mailcatcher`
* run `mailcatcher` to start the daemon, and watch the inbox at: http://localhost:1080/
* send all emails with: `... SMTP_ADDRESS=localhost SMTP_PORT=1025 bundle exec rake tricle:emails:send`

and navigate to [localhost:3000/mail_view](http://localhost:3000/mail_view).

#### Standalone

```bash
bundle exec rake tricle:preview
open http://localhost:8080
```

## Sparklines

Sparklines for each stat are by default included as attachments in the email, and displayed inline. If there are many metrics in an email, email clients like gmail may struggle to render all the images inline successfully on first load. An alternative is to provide S3 credentials to let tricle upload the sparklines to a bucket of your choosing. Use the following environment variables to do so:
* `S3_BUCKET`, default: "tricle"
* `S3_ACCESS_KEY_ID`
* `S3_SECRET_ACCESS_KEY`

The default location for each sparkline will be the path: `sparklines/year-month-day/filename` inside the `S3_BUCKET` specified.

## Deploying

To send all Tricle emails, run

```bash
rake tricle:emails:send
```

To send a particular Tricle email, pass the Mailer classes as arguments to the same task separated by a colon (":")
    * e.g.`... rake tricle:emails:send[MyTeamDashboard]`

To set a speficic time zone, use the `TZ` environment variable (see the list [here](http://en.wikipedia.org/wiki/List_of_tz_database_time_zones)).

```bash
TZ=UTC rake tricle:emails:send
```

### Cron Setup

TODO
