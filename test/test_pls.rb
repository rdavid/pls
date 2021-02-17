# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# Copyright 2021 by David Rabkin

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
