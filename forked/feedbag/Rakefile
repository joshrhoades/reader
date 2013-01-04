require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'lib'
    t.pattern = 'test/*_test.rb'
    t.verbose = true
    t.output_dir = 'coverage'
    t.rcov_opts << '--exclude "gems/*"'
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

desc 'Test muck-feedbag.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = FileList["test/feedbag_test.rb"]
  t.verbose = true
end

task :test => :check_dependencies
task :default => :test

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "muck-feedbag"
    gem.summary = "Fork of the feedbag gem."
    gem.description = "This gem will return title and url for each feed discovered at a given url"
    gem.email = "justin@tatemae.com"
    gem.homepage = "http://github.com/tatemae/muck-feedbag"
    gem.authors = ["Axiombox", "David Moreno", "Joel Duffin", "Justin Ball", "Fabien Penso"]
    gem.add_development_dependency "shoulda"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "muck-feedbag #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
