# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# SPDX-FileCopyrightText: 2021-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'httparty'
require 'json'
require_relative 'configurator'
require_relative 'reporter'

module Pls
  # The data structure is a hash: the key is the package name, the value is
  # an array of hashes, for example:
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
      @dat = {}
      @mut_dat = Mutex.new
    end

    def read_http(pac)
      url = "#{@cfg.url}/#{pac}/latest"
      res = HTTParty.get(url)
      raise "Unable to continue with #{url}." unless res.code == 200

      res.body
    end

    def build_dep(dep)
      arr = []
      threads = []
      mut = Mutex.new
      dep.each_key do |pac|
        threads << Thread.new(pac, arr) do |p, a|
          dat = build(p)
          mut.synchronize { a << dat }
        end
      end
      threads.each(&:join)
      arr
    end

    # Consider adding time-based invalidation for cached data.
    def read_cache(pac)
      arr = []
      @mut_dat.synchronize { arr = @dat[pac] }
      arr
    end

    def write_cache(pac, arr)
      @mut_dat.synchronize { @dat[pac] = arr }
    end

    def build(pac)
      arr = read_cache(pac)
      if arr.to_a.empty?
        str = read_http(pac)
        doc = JSON.parse(str)
        dep = doc['dependencies']
        arr = dep.to_a.empty? ? [] : build_dep(dep)
        write_cache(pac, arr)
      end
      { pac => arr }
    end

    def do
      @rep.do(build(@cfg.pac))
    end
  end
end
