require "rake/clean"

CLEAN.include ["visibility_checker-*.gem", "rdoc", "coverage"]

desc "Build visibility_checker gem"
task :package=>[:clean] do |p|
  sh %{#{FileUtils::RUBY} -S gem build visibility_checker.gemspec}
end

### Specs

desc "Run specs"
task :test do
  sh "#{FileUtils::RUBY} #{"-w" if RUBY_VERSION >= '3'} #{'-W:strict_unused_block' if RUBY_VERSION >= '3.4'} test/visibility_checker_test.rb"
end

task :default => :test

desc "Run specs with coverage"
task :test_cov do
  ENV['COVERAGE'] = '1'
  sh "#{FileUtils::RUBY} test/visibility_checker_test.rb"
end

### RDoc

require "rdoc/task"

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.options += ['--inline-source', '--line-numbers', '--title', 'VisibilityChecker: Detect method visibility changes', '--main', 'README.rdoc', '-f', 'hanna']
  rdoc.rdoc_files.add %w"README.rdoc CHANGELOG MIT-LICENSE lib/**/*.rb"
end

