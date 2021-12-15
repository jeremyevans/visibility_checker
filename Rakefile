require "rake"
require "rake/clean"

CLEAN.include ["visibility_checker-*.gem", "rdoc", "coverage"]

desc "Build visibility_checker gem"
task :package=>[:clean] do |p|
  sh %{#{FileUtils::RUBY} -S gem build visibility_checker.gemspec}
end

### Specs

desc "Run specs"
task :test do
  sh "#{FileUtils::RUBY} #{"-w" if RUBY_VERSION >= '3'} test/visibility_checker_test.rb"
end

task :default => :test

### RDoc

RDOC_DEFAULT_OPTS = ["--quiet", "--line-numbers", "--inline-source", '--title', 'VisibilityChecker: Detect method visibility changes']

begin
  gem 'hanna-nouveau'
  RDOC_DEFAULT_OPTS.concat(['-f', 'hanna'])
rescue Gem::LoadError
end

require "rdoc/task"
RDOC_OPTS = RDOC_DEFAULT_OPTS + ['--main', 'README.rdoc']
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.options += RDOC_OPTS
  rdoc.rdoc_files.add %w"README.rdoc CHANGELOG MIT-LICENSE lib/**/*.rb"
end
