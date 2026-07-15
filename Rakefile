# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2021-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'rake/clean'
require 'bundler/gem_helper'

CLOBBER.include 'pkg'

module Bundler
  # Bundler hardcodes the release tag as "v#{version}", this project
  # tags releases with the bare version number instead.
  class GemHelper
    def version_tag
      version.to_s
    end
  end
end

Bundler::GemHelper.install_tasks

task default: %w[test]

desc 'Run the test suite'
task :test do
  ruby 'test/test_pls.rb'
end
