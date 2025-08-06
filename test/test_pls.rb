# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# SPDX-FileCopyrightText: 2021-2025 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'minitest/autorun'
require_relative '../lib/pls/pls'

# Main functions.
class TestPls < Minitest::Test
  def setup
    ARGV << '-pexpress'
    @pls = Pls::Pls.new
  end

  def test_pls
    @pls.do
  end
end
