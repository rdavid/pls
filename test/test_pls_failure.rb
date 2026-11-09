# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../lib/pls/pls'

# Verifies that registry and command-line errors reach the caller.
class TestPlsFailure < Minitest::Test
  URL = 'https://registry.npmjs.org'

  def setup
    ARGV.replace(['--pac', 'root'])
    @pls = Pls::Pls.new
  end

  def test_build_raises_on_missing_package
    stub_request(:get, "#{URL}/root/latest").to_return(status: 404)
    error = assert_raises(RuntimeError) { @pls.build('root') }

    assert_equal("Unable to fetch #{URL}/root/latest.", error.message)
  end

  def test_build_raises_on_unavailable_dependency
    stub_request(:get, "#{URL}/root/latest")
      .to_return(status: 200, body: '{"dependencies":{"gone":"*"}}')
    stub_request(:get, "#{URL}/gone/latest").to_return(status: 500)
    error = nil

    capture_io do
      error = assert_raises(RuntimeError) { @pls.build('root') }
    end

    assert_equal("Unable to fetch #{URL}/gone/latest.", error.message)
  end

  def test_build_raises_on_invalid_json
    stub_request(:get, "#{URL}/root/latest")
      .to_return(status: 200, body: 'not json')

    assert_raises(JSON::ParserError) { @pls.build('root') }
  end

  def test_build_does_not_cache_failed_package
    stub = stub_request(:get, "#{URL}/root/latest").to_return(status: 503)

    2.times { assert_raises(RuntimeError) { @pls.build('root') } }

    assert_requested(stub, times: 2)
  end

  def test_positional_argument_without_flag_raises
    ARGV.replace(['express'])
    error = assert_raises(RuntimeError) { Pls::Configurator.new }

    assert_match(/Specify a package name/, error.message)
  end

  def test_flag_without_value_raises
    ARGV.replace(['--pac'])

    assert_raises(OptionParser::MissingArgument) { Pls::Configurator.new }
  end

  def test_unknown_flag_raises
    ARGV.replace(['--unknown'])

    assert_raises(OptionParser::InvalidOption) { Pls::Configurator.new }
  end
end
