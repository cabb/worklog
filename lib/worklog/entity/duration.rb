# frozen_string_literal: true

module Worklog
  # how long something was done
  #
  # duration: 4h45m
  # time_str: 04:45
  # sap_time_str: 04:75
  # seconds: 260
  class Duration
    # matches duration in string format e.g. 3h40m
    DURATION_REGEX = /(\d+)([hm]{1})/.freeze

    TOKENS = {
      'h' => (60 * 60),
      'm' => 60
    }.freeze

    class << Duration
      def parse(input)
        seconds = 0
        input.scan(DURATION_REGEX).each do |amount, measure|
          seconds += amount.to_i * TOKENS[measure] if TOKENS.key?(measure)
        end
        Duration.new(seconds: seconds)
      end

      def valid_str?(input)
        DURATION_REGEX.match?(input)
      end
    end

    attr_reader :seconds
    attr_reader :hours
    attr_reader :minutes

    def initialize(seconds: 0)
      @seconds = seconds

      @hours = seconds / TOKENS['h']
      @minutes = ((seconds % TOKENS['h']) / TOKENS['m'])
    end

    def +(other)
      new_sec = parse_value(other)
      Duration.new(seconds: @seconds + new_sec)
    end

    def to_sap_time_str
      format('%<hours>02d:%<minutes>02d', hours: @hours, minutes: @minutes * 100 / 60)
    end

    def to_time_str
      format('%<hours>02d:%<minutes>02d', hours: @hours, minutes: @minutes)
    end

    def to_time
      Time.parse(format('%<hours>02d:%<minutes>02d', hours: @hours, minutes: @minutes))
    end

    # converts the amount of seconds to a duration string e.g. 3h40m
    def to_s
      format('%<hours>02dh%<minutes>02dm', hours: @hours, minutes: @minutes)
    end

    private

    def parse_value(a)
      if a.is_a?(Duration)
        a.seconds
      elsif a.is_a?(Numeric)
        a
      else
        0
      end
    end
  end
end
