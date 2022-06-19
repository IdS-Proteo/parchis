# necessary for minitest tests
require 'rake/testtask'
# necessary for yardoc task
require 'yard'

require 'minitest'

#################TASKS#######################

# to execute minitest tests with `rake test`
Rake::TestTask.new do |t|
  # search recursively under the folder test for files called ts*. There's only one, the general test suite.
  t.pattern = 'test/**/ts*.rb'
end

task :default => :test

# generate yard documentation
YARD::Rake::YardocTask.new {|t|}

desc 'ocra --windows'
task :ocra_windows, :version do |t, args|
  args.with_defaults(:version => '')
  system("ocra --icon './assets/img/icons/parchis.ico' --gemfile Gemfile --windows --add-all-core --gem-full --dll ruby_builtin_dlls/zlib1.dll --dll ruby_builtin_dlls/libssp-0.dll --dll ruby_builtin_dlls/libgmp-10.dll --dll ruby_builtin_dlls/libffi-7.dll --dll ruby_builtin_dlls/libgcc_s_seh-1.dll --dll ruby_builtin_dlls/libssl-1_1-x64.dll --dll ruby_builtin_dlls/libwinpthread-1.dll --dll ruby_builtin_dlls/libyaml-0-2.dll --dll ruby_builtin_dlls/libcrypto-1_1-x64.dll --output 'releases/parchis#{args[:version].!=('') ? "_#{args[:version]}" : ''}.exe' './bin/parchis' './assets/**/*' './lib/**/*'")
end
