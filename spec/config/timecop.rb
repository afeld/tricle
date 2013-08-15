require 'timecop'

def reset_time
  # need to freeze the time for the TestMetric
  now = Time.new(2013, 8, 1, 1, 0, 0, '-04:00')
  Timecop.freeze(now)
end
