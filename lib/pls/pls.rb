# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# Copyright 2021 by David Rabkin

require 'httparty'
require 'json'
require_relative 'configurator'
require_relative 'reporter'

module Pls
  # Data structure is hash, key - package name, val - array of hashes:
  # {
  #   aaa => [
  #            bbb => [],
  #            ccc => [
  #                     ddd => [],
  #                     eee => []
  #                   ]
  #          ]
  # }
  class Pls
    def initialize
      @cfg = Configurator.new
      @rep = Reporter.new
    end

    def read(pac)
      url = "#{@cfg.url}/#{pac}/latest"
      res = HTTParty.get(url)
      raise "Unable to continue with #{url}." unless res.code == 200

      res.body
    end

    def build_dep(dep)
      arr = []
      dep.to_a.empty? || dep.each_key { |sub| arr.push(build(sub)) }
      arr
    end

    def build(pac)
      str = read(pac)
      doc = JSON.parse(str)
      dep = doc['dependencies']
      { pac => build_dep(dep) }
    end

    def do
      @rep.do(build(@cfg.pac))
    end
  end
end
