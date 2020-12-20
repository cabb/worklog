# frozen_string_literal: true

module Worklog
  # a day can contain multiple activities
  class Day
    include Comparable

    def initialize(start: Time.now)
      @start = start
      @activities = []

      @work_time = Duration.new
      @pause_time = Duration.new
    end

    def <=>(other)
      @start <=> other.start
    end

    attr_reader :activities, :pause_time, :start, :work_time

    class << Day
      def parse(hash)
        day = Day.new(start: Time.parse(hash[:start]))
        hash[:activities].each do |act_hash|
          act = parse_activitiy(act_hash.transform_keys(&:to_sym))
          day.add(act)
        end
        day
      end

      private

      def parse_activitiy(hash)
        case hash[:type]
        when 'A'
          Activity.parse(hash)
        when 'P'
          Pause.parse(hash)
        end
      end
    end

    def activities?
      !@activities.empty?
    end

    def add(activity)
      @activities << activity
      if activity.pause?
        @pause_time += activity.duration
      else
        @work_time += activity.duration
      end
    end

    def breaks
      @activities.select(&:pause?)
    end

    # returns the end time of the
    # it can either be the start of the day or the end of the last activity or break
    def end
      if @activities.empty?
        @start
      else
        @activities[-1].end
      end
    end

    #
    # returns a hash of all topics and the total duration
    # hash is sorted by the key
    def duration_by_topic
      return {} if @activities.empty?

      calc_duration_by_topic.to_h
    end

    def summary
      format('%<date>s: %<start>s - %<end>s * P %<pause>s (%<work>s)',
             {
               date: @start.strftime('%Y-%m-%d'),
               start: @start.strftime('%H:%M'),
               end: self.end.strftime('%H:%M'),
               pause: @pause_time.to_time_str,
               work: @work_time.to_time_str
             })
    end

    # returns the topic and the time
    # If extend is set to true, all topics will also have their texts
    def summary_topics(extend: false)
      topics = duration_by_topic

      if extend == true
        return topics.map do |name, topic|
          name = '(empty)' if name.nil?
          "#{topic[:duration].to_time_str} - #{name} - #{topic[:text]}"
        end
      end
      topics.map do |name, topic|
        name = '(empty)' if name.nil?
        "#{topic[:duration].to_time_str} - #{name} - #{percentage_of_work(topic[:duration])}%"
      end
    end

    def to_hash
      {
        start: format_start_date,
        activities: @activities.map(&:to_hash)
      }
    end

    private

    def format_start_date
      Tools.format_date_time(@start)
    end

    def calc_duration_by_topic
      groups = {}
      # flatten array and perform artimetic operation
      @activities.each do |act|
        next if act.pause?

        if groups.key?(act.topic)
          groups[act.topic][:duration] += act.duration
          groups[act.topic][:text] += "; #{act.text}"
        else
          groups[act.topic] = { duration: act.duration, text: act.text }
        end
      end
      groups
    end

    def percentage_of_work(duration)
      ((duration.seconds * 100) / @work_time.seconds).to_i
    end
  end
end
