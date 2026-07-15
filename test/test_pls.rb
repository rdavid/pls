# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# SPDX-FileCopyrightText: 2021-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'minitest/autorun'
require_relative '../lib/pls/pls'

# Verifies package listing works end to end.
class TestPls < Minitest::Test
  def setup
    ARGV << '-pexpress'
    @pls = Pls::Pls.new
  end

  def test_pls
    @pls.do
  end

  def test_build_reuses_cache_for_packages_without_dependencies
    original = HTTParty.method(:get)
    calls = 0
    res = Struct.new(:code, :body).new(200, '{"dependencies":{}}')
    HTTParty.define_singleton_method(:get) do |*_args|
      calls += 1
      res
    end
    @pls.build('leaf')
    @pls.build('leaf')
    assert_equal 1, calls
  ensure
    HTTParty.define_singleton_method(:get, original)
  end
end
