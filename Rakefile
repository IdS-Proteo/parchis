# necessary for minitest tests
require 'rake/testtask'
# necessary for yardoc task
require 'yard'

#################TASKS#######################

# to execute minitest tests with `rake test`
Rake::TestTask.new do |t|
  # search recursively under the folder test for files called ts*. There's only one, the general test suite.
  t.pattern = 'test/**/ts*.rb'
  #generate xml file for jenkins NOT WORKING ATM BUT THIS IS WHAT SHOULD WORK
  t.options = '--junit --junit-filename=test/junit.xml --junit-jenkins'
end

# generate yard documentation
YARD::Rake::YardocTask.new {|t|}
