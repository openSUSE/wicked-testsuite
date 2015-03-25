require 'twopence'
require 'rspec'

# Final cleanup
at_exit do
  SUT.test_and_drop_results "log.sh --results"
end
