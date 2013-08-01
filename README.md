# Tricle

Automated metrics reporting via email.  It's datastore-agnostic, so you can query SQL, MongoDB, external APIs, etc. to generate the stats you need.

## Installation

### Gem

This gem can be used within an existing project (e.g. a Rails app), or standalone.  In either case, add this line to your Gemfile:

```ruby
gem 'tricle'
```

You'll also need to [configure ActiveMailer](http://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration) if your project doesn't include this already.  Next, execute:

    $ bundle

### Cron

TODO

## Usage

### Metrics

For each metric you want to report, create a new subclass of `Tricle::Metric` that implements `#for_range`:

```ruby
class MyMetric < Tricle::Metric

  # Retrieve the value of this metric for the provided time period.
  # Generally this will be the number added/removed.
  #
  # @param start_at [Time]
  # @param end_at [Time]
  # @return [Fixnum]
  def for_range(start_at, end_at)
    # ...
  end

  # Retrieve the cumulative value for this metric.
  #
  # @return [Fixnum]
  def total
    # ...
  end

end
```

ActiveRecord example:

```ruby
# metrics/new_users.rb
class NewUsers < Tricle::Metric

  # Retrieve the number of users added between the provided times.
  def for_range(start_at, end_at)
    self.users.where('created_at >= ? AND created_at < ?', start_at, end_at).count
  end

  # Grand total User count.
  def total
    self.users.count
  end


  private

  def users
    # non-deleted Users
    User.where(deleted_at: nil)
  end

end
```

You can also add whatever helper methods in that class that you need.

### Reports

Reports assemble ordered lists of Metrics.

```ruby
class MyReport < Tricle::Report

  # @return [Array<Tricle::Metric>]
  def metrics
    [
      # MyMetric1,
      # MyMetric2,
      # ...
    ]
  end

end
```

e.g.

```ruby
class ArtsyInsights < Tricle::Report

  def metrics
    [NewUsers]
  end

end
```

The subject line will be based on the Report class name.

### Mailers

Mailers specify how a particular Report should be sent.

```ruby
class MyMailer < Tricle::Mailer

  # @return [:daily, :weekly]
  def frequency
    # ...
  end

  # @return [Tricle::Report]
  def report
    # ...
  end

  # @return [Array<String>]
  def recipients
    # ...
  end

end
```

e.g.

```ruby
# mailers/weekly_insights.rb
class WeeklyInsights < Tricle::Mailer

  def frequency
    :weekly
  end

  def report
    ArtsyInsights
  end

  def recipients
    ["theteam@mycompany.com", "theboss@mycompany.com"]
  end

end
```
