# frozen_string_literal: true

module Worklog
  # close to an activity but without a topic
  class Pause < Activity
    TYPE = 'P'

    def initialize(start:, duration:, text: '')
      super(start: start, duration: duration, text: text, type: TYPE)
    end

    class << Pause
      def parse(hash)
        hash[:start] = Time.parse(hash[:start])
        hash.delete(:type)
        Pause.new(**hash)
      end
    end

    def summary
      format('%<duration>s - BREAK: %<text>s',
             {
               duration: @duration.to_time_str,
               text: @text
             })
    end
  end
end
