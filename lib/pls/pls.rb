# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# Copyright 2021 by David Rabkin

require 'httparty'
require 'json'
require_relative 'configurator'
require_relative 'reporter'

module Pls
  # Main functionality.
  class Pls
    def initialize
      @cfg = Configurator.new
      @rep = Reporter.new
      @dat = [@cfg.pac]
    end

    def read(pac)
      url = "#{@cfg.url}/#{pac}/latest"
      res = HTTParty.get(url)
      raise "Unable to continue with #{url}." unless res.code == 200

      res.body
    end

    def do
      str = read(@cfg.pac)
      doc = JSON.parse(str)
      doc['dependencies'].each do |pac|
        @dat.push(pac[0])
      end
      @rep.do(@dat)
    end
  end
end
