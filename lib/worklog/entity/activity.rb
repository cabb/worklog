# frozen_string_literal: true

module Worklog
  # representation of something you did
  class Activity
    TOPIC_TEXT_REGEX = /^(?<topic>[A-Z0-9\-_]+)? (?<text>.*)?$/.freeze
    TYPE = 'A'

    attr_reader :end, :duration, :text, :start, :topic

    def initialize(start:, duration:, text: '', type: TYPE)
      @start = start
      @duration = Duration.parse(duration)
      @topic, @text = parse_text(text)
      @type = type

      @end = @start + @duration.seconds
    end

    class << Activity
      def parse(hash)
        hash[:start] = Time.parse(hash[:start])
        Activity.new(**hash)
      end
    end

    def to_hash
      {
        type: @type,
        start: format_start,
        duration: @duration.to_s,
        text: concat_text
      }
    end

    def pause?
      Pause::TYPE == @type
    end

    def summary
      format('%<duration>s - %<text>s (%<topic>s)',
             {
               duration: @duration.to_time_str,
               text: @text,
               topic: @topic
             })
    end

    def format_start
      @start.to_s
    end

    def parse_text(text)
      parts = text.match(TOPIC_TEXT_REGEX)
      return nil, text if parts.nil?

      [parts[:topic], parts[:text]]
    end

    def concat_text
      return "#{@topic} #{@text}" if @topic

      @text
    end
  end
end
