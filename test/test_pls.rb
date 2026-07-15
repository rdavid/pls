# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2021-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../lib/pls/pls'

# Verifies package listing works end to end.
class TestPls < Minitest::Test
  def setup
    ARGV << '-pexpress'
    @pls = Pls::Pls.new
  end

  def test_pls
    stub_request(:get, 'https://registry.npmjs.org/express/latest')
      .to_return(status: 200, body: '{"dependencies":{}}')
    out, = capture_io { @pls.do }

    assert_match(/express/, out)
  end

  def test_build_reuses_cache_for_packages_without_dependencies
    stub = stub_request(:get, 'https://registry.npmjs.org/leaf/latest')
           .to_return(status: 200, body: '{"dependencies":{}}')
    @pls.build('leaf')
    @pls.build('leaf')

    assert_requested(stub, times: 1)
  end
end
