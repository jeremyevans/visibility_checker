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

desc "Generate rdoc"
task :rdoc do
  rdoc_dir = "rdoc"
  rdoc_opts = ["--line-numbers", "--inline-source", '--title', 'VisibilityChecker: Detect method visibility changes']

  begin
    gem 'hanna'
    rdoc_opts.concat(['-f', 'hanna'])
  rescue Gem::LoadError
  end

  rdoc_opts.concat(['--main', 'README.rdoc', "-o", rdoc_dir] +
    %w"README.rdoc CHANGELOG MIT-LICENSE" +
    Dir["lib/**/*.rb"]
  )

  FileUtils.rm_rf(rdoc_dir)

  require "rdoc"
  RDoc::RDoc.new.document(rdoc_opts)
end
