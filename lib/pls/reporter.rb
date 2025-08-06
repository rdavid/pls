# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# SPDX-FileCopyrightText: 2021-2025 David Rabkin
# SPDX-License-Identifier: 0BSD

module Pls
  # Formats and prints output data.
  class Reporter
    def initialize
      @beg = Time.now.to_i
    end

    def out(pac, del)
      key = pac.keys[0]
      del.times { print ' ' }
      print key
      puts "\n"
      pac[key].each { |sub| out(sub, del + 2) }
    end

    def do(dat)
      out(dat, 0)
      puts "Done in #{Time.now.to_i - @beg} seconds."
    end
  end
end
