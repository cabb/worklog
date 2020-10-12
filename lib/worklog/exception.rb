# frozen_string_literal: true

module Worklog
  # exception class for command arguments
  class CommandArgumentError < ArgumentError
    def initialize(msg = 'Invalid argument', exception_type = 'custom')
      @exception_type = exception_type
      super(msg)
    end
  end
end
