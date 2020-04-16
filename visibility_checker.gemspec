spec = Gem::Specification.new do |s|
  s.name = 'visibility_checker'
  s.version = '1.0.0'
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG", "MIT-LICENSE"]
  s.rdoc_options += ["--quiet", "--line-numbers", "--inline-source", '--title', 'VisibilityChecker: Detect method visibility changes', '--main', 'README.rdoc']
  s.license = "MIT"
  s.summary = "Detect method visibility changes"
  s.author = "Jeremy Evans"
  s.email = "code@jeremyevans.net"
  s.homepage = "http://github.com/jeremyevans/visibility_checker"
  s.files = %w(MIT-LICENSE CHANGELOG README.rdoc) + Dir["lib/**/*.rb"]
  s.description = <<END
VisibilityChecker exposes a single method, visibility_changes, for returning
an array with places where any ancestor of the given class has changed the
visibility of any of the classes's methods.
END
  s.metadata = {
    'bug_tracker_uri'   => 'https://github.com/jeremyevans/visibility_checker/issues',
    'changelog_uri'     => 'https://github.com/jeremyevans/visibility_checker/blob/master/CHANGELOG',
    'source_code_uri'   => 'https://github.com/jeremyevans/visibility_checker',
  }
  s.required_ruby_version = ">= 2.0.0"
  s.add_development_dependency('minitest')
  s.add_development_dependency "minitest-global_expectations"
end
