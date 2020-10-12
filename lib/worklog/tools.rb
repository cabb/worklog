# frozen_string_literal: true

module Worklog
  # time operations
  module Tools
    # for parsing common way to write times in 24h way, e.g. 10:25
    TIME_REGEX = /^(?<h>[0-1]?[0-9]|2[0-3])(:(?<m>[0-5][0-9]))?$/.freeze

    refine Integer do
      def to_duration
        Duration.new(seconds: self)
      end
    end

    class << self
      def parse_time(input)
        time_parts = input.match(TIME_REGEX)
        return if time_parts.nil?

        time_str = format(
          '%<hours>s:%<minutes>s',
          hours: format_number(time_parts[:h]),
          minutes: format_number(time_parts[:m])
        )
        Time.parse(time_str)
      end

      def correct_time_format?(input)
        TIME_REGEX.match?(input)
      end

      def format_date_time(date)
        date.strftime('%F') + ' ' + date.strftime('%T')
      end

      private

      def format_number(num)
        return '00' if num.nil?

        if num.length == 1
          '0' + num
        else
          num
        end
      end
    end
  end
end
