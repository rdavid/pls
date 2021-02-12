# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# Copyright 2021 by David Rabkin

module Pls
  # Formats and prints output data.
  class Reporter
    def initialize
      @beg = Time.now.to_i
    end

    def do(con)
      puts con
      puts "Done in #{Time.now.to_i - @beg}."
    end
  end
end
