require 'timecop'

def reset_time
  # need to freeze the time for the TestMetric
  # 1AM, Thursday, August 1, 2013
  now = Time.new(2013, 8, 1, 1, 0, 0)
  Timecop.freeze(now)
end
