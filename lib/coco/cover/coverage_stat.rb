module Coco

  # Public: Give statistics about an array of lines hit.
  #
  # An "array of lines hit" is an array of integers, possibly nil.
  # Such array is obtain from Coverage.result.
  #
  # Each integer represent the state of a source line:
  # * nil: source line will never be reached (like comments).
  # * 0: source line could be reached, but was not.
  # * 1 and above: number of time the source line has been reached.
  #
  module CoverageStat

    # Public: Compute the decimal percentage of code coverage for a file.
    # The file is represented by an array of hits.
    #
    # hits - Array of Integer.
    #
    # Returns a Float percentage of coverage.
    #
    def self.real_percent(hits)
      hits = hits.compact
      return 0 if hits.empty?
      one_percent = 100.0 / hits.size
      number_of_covered_lines(hits) * one_percent
    end

    # Public: Compute the integer percentage of code coverage for a file.
    # The file is represented by an array of hits.
    #
    # hits - Array of Integer.
    #
    # Returns a Integer rounded percentage of coverage.
    #
    def self.coverage_percent(hits)
      real_percent(hits).round
    end

    # Compute the total of covered lines in a hits array.
    #
    # hits - Array of Integer.
    #
    # Returns Integer.
    #
    def self.number_of_covered_lines(hits)
      hits.select { |hit| hit > 0 }.size
    end
  end
end
