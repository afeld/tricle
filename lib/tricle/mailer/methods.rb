require 'active_support/concern'

require_relative '../../../spec/app/group_test_mailer.rb'
require_relative '../../../spec/app/list_test_mailer.rb'
require_relative '../../../spec/app/test_mailer.rb'
require_relative '../../../spec/app/uber_test_mailer.rb'

module Tricle
  class Mailer
    module Methods
      extend ActiveSupport::Concern

      included do
        Tricle::Mailer.descendants.each do |klass|
          define_method(klass.name.underscore) { klass.email }
        end
      end
    end
  end
end
