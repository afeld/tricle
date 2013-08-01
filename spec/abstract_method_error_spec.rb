require 'spec_helper'

describe Tricle::AbstractMethodError do
  class TestAbstractMethod
    def foo
      raise Tricle::AbstractMethodError.new
    end
  end

  it "should include the method name in the message" do
    expect {
      TestAbstractMethod.new.foo
    }.to raise_error("#foo not implemented")
  end
end
