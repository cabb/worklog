# frozen_string_literal: true

module Worklog
  # the log file
  class LogFile
    DEFAULT_CONTENT = {
      'type' => 'worklog',
      'version' => VERSION,
      'logs' => []
    }.freeze

    KEY_ACTIVITIES = 'activities'
    KEY_LOGS = 'logs'

    def initialize(filename = 'data/work.log')
      @filename = filename
      ensure_file_exists
    end

    def active_day
      json_hash = read
      json_hash[KEY_LOGS][-1]&.transform_keys(&:to_sym)
    end

    def append_activity(activity)
      json_hash = read
      json_hash[KEY_LOGS][-1][KEY_ACTIVITIES] << activity.to_hash
      write(json_hash)
    end

    def append_day(day)
      json_hash = read
      json_hash[KEY_LOGS] << day.to_hash
      write(json_hash)
    end

    # returns the 'log' content of the json file
    def content
      read['logs'].map { |day| day.transform_keys(&:to_sym) }
    end

    def delete_last_activity
      json_hash = read
      json_hash[KEY_LOGS][-1][KEY_ACTIVITIES].pop
      write(json_hash)
    end

    def delete_last_day
      json_hash = read
      json_hash[KEY_LOGS].pop
      write(json_hash)
    end

    private

    def ensure_file_exists
      return if File.exist?(@filename)

      File.open(@filename, 'w:UTF-8') do |f|
        f.write(DEFAULT_CONTENT.to_json)
      end
    end

    def read
      content = File.open(@filename, 'r:UTF-8', &:read)
      JSON.parse(content)
    end

    def write(json_hash)
      File.open(@filename, 'w:UTF-8') do |f|
        f.puts JSON.pretty_generate(json_hash)
      end
    end
  end
end
