# necessary for minitest tests
require 'rake/testtask'
# necessary for yardoc task
require 'yard'

#################TASKS#######################

# to execute minitest tests with `rake test`
Rake::TestTask.new do |t|
  # search recursively under the folder test for files called test*. You may have to create the folder manually.
  t.pattern = 'test/**/test*.rb'
end

# generate yard documentation
YARD::Rake::YardocTask.new {|t|}
