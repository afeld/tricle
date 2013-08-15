require 'spec_helper'

require_relative '../../../lib/tricle/presenters/report/weekly'

describe Tricle::Presenters::Report::Weekly do
  let(:report) { Tricle::Presenters::Report::Weekly.new }

  describe "#single_week_dates_cell" do
    it "should not include the last day of the week" do
      start_at = Time.new(2013, 7, 22) # a Monday
      markup = report.single_week_dates_cell(start_at)
      markup.should include('7/22/13')
      markup.should include('7/28/13')
    end
  end
end
