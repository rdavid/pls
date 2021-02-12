# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# Copyright 2021 by David Rabkin

require 'optparse'

module Pls
  # Handles input parameters.
  class Configurator
    attr_reader :files

    DIC = [
      ['-p', '--pac package', 'Package name.', String, :pac]
    ].freeze

    def add(opt)
      opt.on('-v', '--version', 'Show version.') do
        puts "#{File.basename($PROGRAM_NAME)} #{VERSION} #{DATE}"
        exit
      end
    end

    def initialize
      @options = {}
      OptionParser.new do |o|
        o.banner = "Usage: #{File.basename($PROGRAM_NAME)} [options]."
        DIC.each { |f, p, d, t, k| o.on(f, p, t, d) { |i| @options[k] = i } }
        add(o)
      end.parse!
    end

    def dir
      @options[:pac]
    end
  end
end
