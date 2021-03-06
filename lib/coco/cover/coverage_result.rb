module Coco

  # Compute results of interest from the big results information (from
  # Coverage.result)
  #
  class CoverageResult

    # Returns a Hash coverage for all the sources that live in the root
    # project folder.
    #
    attr_reader :coverable_files

    # Returns a Hash coverage for sources that are not sufficiently
    # covered. More technically, the sources that live in the root
    # project folder and for which the coverage percentage is under the
    # threshold.
    #
    attr_reader :not_covered_enough

    # Public: Initialize a CoverageResult.
    #
    # config      - Hash
    # raw_results - The Hash from Coverage.result. Keys are filenames
    #               and values are an Array representing each lines of
    #               the file :
    #               + nil       : Unreacheable (comments, etc).
    #               + 0         : Not hit.
    #               + 1 or more : Number of hits.
    #
    def initialize(config, raw_results)
      raise ArgumentError if config[:threshold] < 0

      @exclude_files = config[:exclude]
      @threshold = config[:threshold]
      @result = raw_results

      exclude_external_sources
      exclude_files_user_dont_want if @exclude_files

      @not_covered_enough = if config[:exclude_above_threshold]
                              exclude_sources_above_threshold
                            else
                              @coverable_files
                            end
    end

    # Public: Count the number of "coverable" files.
    #
    # Returns the Fixnum number of files.
    #
    def count
      coverable_files.size
    end

    # Public: Count the number of uncovered files, that is, files with a
    # coverage rate of 0%.
    #
    # Returns the Fixnum number of uncovered files.
    #
    def uncovered_count
      not_covered_enough.select do |_, hits|
        CoverageStat.coverage_percent(hits).zero?
      end.size
    end

    # Public: Computes the average coverage rate.
    # The formula is simple:
    #
    # N = number of files
    # f = a file
    # average = sum(f_i%) / N
    #
    # In words: Take the sum of the coverage's percentage of all files
    # and divide this sum by the number of files.
    #
    # Returns the Fixnum rounded average rate of coverage.
    #
    def average
      files_present? ? (sum / count).round : 0
    end

    private

    def exclude_external_sources
      here = Dir.pwd
      @coverable_files = @result.select { |key, _| key.start_with?(here) }
    end

    def exclude_files_user_dont_want
      @exclude_files.each do |filename|
        @coverable_files.delete(File.expand_path(filename))
      end
    end

    def exclude_sources_above_threshold
      @coverable_files.select do |_, value|
        CoverageStat.coverage_percent(value) < @threshold
      end
    end

    # Returns the Float sum of all files' percentage.
    #
    def sum
      @coverable_files.values.map do |hits|
        CoverageStat.real_percent(hits)
      end.reduce(&:+)
    end

    def files_present?
      count > 0
    end
  end
end
