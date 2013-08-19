# Tricle [![Build Status](https://travis-ci.org/artsy/tricle.png?branch=master)](https://travis-ci.org/artsy/tricle) [![Code Climate](https://codeclimate.com/github/artsy/tricle.png)](https://codeclimate.com/github/artsy/tricle)

Automated metrics reporting via email.  It's datastore-agnostic, so you can query SQL, MongoDB, external APIs, etc. to generate the stats you need.  See [here](https://github.com/afeld/tricle-afeld) for an example implementation ([live demo](http://tricle.afeld.me/weekly_metrics)).

![screenshot](screenshot.png)

## Installation

### Gem

This gem can be used within an existing project (e.g. a Rails app), or standalone.

```ruby
# Gemfile
gem 'tricle', '~> 0.1.0'

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

  # Retrieve the cumulative value for this metric.
  #
  # @return [Fixnum] the grand total
  def total
    # ...
  end

  # Optional: only necessary if using `list` for this Metric within your Mailer.
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
# metrics/new_users.rb
class NewUsers < Tricle::Metric

  def size_for_range(start_at, end_at)
    self.size_for_range(start_at, end_at).size
  end

  def total
    self.users.count
  end

  def items_for_range(start_at, end_at)
    self.size_for_range(start_at, end_at)
  end


  private

  def size_for_range(start_at, end_at)
    self.users.where('created_at >= ? AND created_at < ?', start_at, end_at)
  end

  # You can add whatever helper methods in that class that you need.
  def users
    # non-deleted Users
    User.where(deleted_at: nil)
  end

end
```

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
# mailers/weekly_insights.rb
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

and navigate to [localhost:3000/mail_view](http://localhost:3000/mail_view).

#### Standalone

```bash
bundle exec rake tricle:preview
open http://localhost:8080
```

## Deploying

To send all Tricle emails, run

```bash
rake tricle:emails:send
```

### Cron Setup

TODO
