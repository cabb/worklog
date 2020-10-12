# frozen_string_literal: true

module Worklog
  # Endless loop
  class Loop
    ARGV_SPLIT_REGEX = /\s(?=(?:[^"]*"[^"]*")*[^"]*$)/.freeze

    def initialize
      @cli = Cli.new
    end

    def run
      loop do
        input = user_input
        @cli.main(to_argv(input))
      end
    end

    def to_argv(string)
      string.split(ARGV_SPLIT_REGEX, 0).map do |param|
        if param.start_with?('"')
          param[1..-2]
        else
          param
        end
      end
    end

    def user_input
      print('Insert action: ')
      gets.chomp
    end
  end
end
