# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2021-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../lib/pls/pls'
require_relative '../lib/pls/version'

# Verifies package listing, dependency caching, and command-line options.
# Sibling order depends on thread timing, so sibling lines are compared sorted.
class TestPls < Minitest::Test
  SHARED_TREE = [
    '      leaf', '      leaf', '    shared', '    shared',
    '  aaa', '  bbb', 'root'
  ].freeze

  def setup
    ARGV.replace(['--pac', 'root'])
    @pls = Pls::Pls.new
  end

  def stub_pac(pac, *deps)
    body = { dependencies: deps.to_h { |dep| [dep, '*'] } }.to_json
    stub_request(:get, "https://registry.npmjs.org/#{pac}/latest")
      .to_return(status: 200, body: body)
  end

  def tree(out)
    out.lines(chomp: true)[0..-2]
  end

  def exit_of(&block)
    error = nil
    out, = capture_io { error = assert_raises(SystemExit, &block) }
    [error, out]
  end

  def test_do_prints_package_and_elapsed_time
    stub_pac('root')
    out, = capture_io { @pls.do }

    assert_match(/\Aroot\nDone in \d+ seconds\.\n\z/, out)
  end

  def test_do_indents_each_dependency_level
    stub_pac('root', 'mid')
    stub_pac('mid', 'leaf')
    stub_pac('leaf')
    out, = capture_io { @pls.do }

    assert_equal(['root', '  mid', '    leaf'], tree(out))
  end

  def test_do_lists_every_sibling
    stub_pac('root', 'aaa', 'bbb')
    stub_pac('aaa')
    stub_pac('bbb')
    out, = capture_io { @pls.do }

    assert_equal(['  aaa', '  bbb', 'root'], tree(out).sort)
  end

  def test_do_prints_cached_subtree_under_each_parent
    stub_pac('root', 'aaa', 'bbb')
    stub_pac('aaa', 'shared')
    stub_pac('bbb', 'shared')
    shared = stub_pac('shared', 'leaf')
    stub_pac('leaf')
    @pls.build('shared')
    out, = capture_io { @pls.do }

    assert_equal(SHARED_TREE, tree(out).sort)
    assert_requested(shared, times: 1)
  end

  def test_build_returns_nested_tree
    stub_pac('root', 'mid')
    stub_pac('mid')

    assert_equal({ 'root' => [{ 'mid' => [] }] }, @pls.build('root'))
  end

  def test_build_treats_missing_dependencies_as_leaf
    stub_request(:get, 'https://registry.npmjs.org/bare/latest')
      .to_return(status: 200, body: '{}')

    assert_equal({ 'bare' => [] }, @pls.build('bare'))
  end

  def test_build_reuses_cache_for_packages_without_dependencies
    stub = stub_pac('leaf')
    @pls.build('leaf')
    @pls.build('leaf')

    assert_requested(stub, times: 1)
  end

  def test_build_reuses_cache_for_packages_with_dependencies
    parent = stub_pac('parent', 'child')
    child = stub_pac('child')
    @pls.build('parent')
    @pls.build('parent')

    assert_requested(parent, times: 1)
    assert_requested(child, times: 1)
  end

  def test_short_flag_sets_package
    ARGV.replace(['-p', 'express'])

    assert_equal('express', Pls::Configurator.new.pac)
  end

  def test_long_flag_sets_package
    ARGV.replace(['--pac', 'express'])

    assert_equal('express', Pls::Configurator.new.pac)
  end

  def test_version_flag_prints_version
    ARGV.replace(['--version'])
    error, out = exit_of { Pls::Configurator.new }

    assert_predicate(error, :success?)
    assert_includes(out, "#{Pls::VERSION} #{Pls::DATE}")
  end

  def test_no_arguments_prints_help
    ARGV.clear
    error, out = exit_of { Pls::Configurator.new }

    assert_predicate(error, :success?)
    assert_includes(out, '--pac package')
  end
end
