notification :gntp

guard :rspec, all_on_start: true do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/}) { 'spec' }
  watch('spec/spec_helper.rb') { 'spec' }
  watch(%r{^spec/}) { 'spec' }
end
