module Tricle
  class AbstractMethodError < RuntimeError
    def to_s
      name = self.backtrace.first[/`(\w+)'/, 1]
      "##{name} not implemented"
    end
  end
end
