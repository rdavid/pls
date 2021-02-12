# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# Copyright 2021 by David Rabkin

require_relative 'configurator'
require_relative 'reporter'

module Pls
  # Transcodes any video file to m4v format.
  class Pls
    def initialize
      @cfg = Configurator.new
      @rep = Reporter.new
    end

    def do
      @rep.do
    end
  end
end
