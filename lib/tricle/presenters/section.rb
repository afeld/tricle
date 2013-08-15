require_relative '../abstract_method_error'

module Tricle
  class Section
    def title
      raise Tricle::AbstractMethodError.new
    end
  end
end
