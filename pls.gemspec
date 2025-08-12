# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# SPDX-FileCopyrightText: 2021-2025 David Rabkin
# SPDX-License-Identifier: 0BSD

$LOAD_PATH.unshift File.expand_path('lib', __dir__)

require 'pls'

Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>= 3.2'
  s.name = 'pls'
  s.version = Pls::VERSION
  s.summary = 'Package lister'
  s.description = <<-HERE
    Prints dependant package names.
  HERE
  s.license = '0BSD'
  s.author = 'David Rabkin'
  s.email = 'david@rabkin.co.il'
  s.homepage = 'https://github.com/rdavid/pls'
  s.require_paths = ['lib']
  s.files = `git ls-files`.split($RS)
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.extra_rdoc_files = ['LICENSE', 'README.adoc']
  s.metadata['rubygems_mfa_required'] = 'true'
end
