# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'pls'

Gem::Specification.new do |s|
  s.name = 'pls'
  s.version = Pls::VERSION
  s.date = Pls::DATE
  s.required_ruby_version = '~> 3.0'
  s.summary = 'Package lister.'
  s.description = <<-HERE
    Prints dependant package names.
  HERE
  s.license = '0BSD'
  s.author = 'David Rabkin'
  s.email = 'david@rabkin.co.il'
  s.homepage = 'https://github.com/rdavid/pls'
  s.files = Dir['{bin,lib}/**/*'] + Dir['[A-Z]*'] + ['pls.gemspec']
  s.executables = ['pls']
  s.extra_rdoc_files = ['LICENSE', 'README.md']
  s.require_paths = ['lib']
  s.add_runtime_dependency 'httparty', '0.21.0'
  s.add_runtime_dependency 'pidfile', '0.3.0'
  s.add_development_dependency 'minitest', '5.11.3'
  s.add_development_dependency 'rake', '13.0.1'
  s.add_development_dependency 'rubocop', '0.76.0'
end
