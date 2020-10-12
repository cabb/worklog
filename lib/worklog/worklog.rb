# frozen_string_literal: true

module Worklog
  # class for logging your work
  class Worklog
    INDENT = '            '
    FILE_NAME = 'data/work.log'

    attr_reader :log

    def initialize(file = FILE_NAME)
      @log = LogFile.new(file)
    end

    def create_day(start: Time.now)
      day = Day.new(start: start)
      @log.append_day(day)
      day
    end

    def delete(day:)
      if day
        @log.delete_last_day
      else
        @log.delete_last_activity
      end
    end

    def log_activity(text:, duration: nil)
      day = Day.parse(@log.active_day)
      # calculate duration if it is empty
      duration = duration_since(day.end) if duration.nil?
      activity = Activity.new(start: day.end, duration: duration, text: text)
      @log.append_activity(activity)

      activity
    end

    def log_pause(text:, duration: nil)
      day = Day.parse(@log.active_day)
      # calculate duration if it is empty
      duration = calc_duration(day.end) if duration.nil?
      pause = Pause.new(start: day.end, duration: duration, text: text)
      @log.append_activity(pause)

      pause
    end

    def list(details: false, overview:)
      days = @log.content.map do |day_hash|
        Day.parse(day_hash)
      end

      days.each do |day|
        puts day.summary
        print_day_activties(day, details) unless overview
      end
    end

    private

    def duration_since(since)
      duration_seconds = (Time.now - since).to_i
      return '0m' if duration_seconds.negative?

      Duration.new(seconds: duration_seconds).to_s
    end

    def print_day_activties(day, details)
      day.summary_topics.each do |topic|
        print_indented topic
      end

      return unless details

      puts '        Details'
      day.activities.each do |act|
        print_indented act.summary
      end
    end

    def print_indented(str)
      print INDENT
      puts str
    end
  end
end
