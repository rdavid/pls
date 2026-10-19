# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2021-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'optparse'

module Pls
  # Parses command-line options for the package name and version flags.
  class Configurator
    attr_reader :files

    DIC = [
      ['-p', '--pac package', 'Sets the package name.', String, :pac]
    ].freeze

    def add(opt)
      opt.on('-v', '--version', 'Shows the version.') do
        puts "#{File.basename($PROGRAM_NAME)} #{VERSION} #{DATE}"
        exit
      end
    end

    def initialize
      ARGV << '-h' if ARGV.empty?
      @options = {}
      OptionParser.new do |o|
        o.banner = "Usage: #{File.basename($PROGRAM_NAME)} [options]."
        DIC.each { |f, p, d, t, k| o.on(f, p, t, d) { |i| @options[k] = i } }
        add(o)
      end.parse!
      raise 'Specify a package name with the -p flag.' if pac.nil?
    end

    def pac
      @options[:pac]
    end

    def url
      'https://registry.npmjs.org'
    end
  end
end
