# frozen_string_literal: true

require 'worklog/entity/activity'
require 'worklog/entity/day'
require 'worklog/entity/duration'
require 'worklog/entity/pause'
require 'worklog/cli'
require 'worklog/exception'
require 'worklog/log_file'
require 'worklog/loop'
require 'worklog/tools'
require 'worklog/worklog'

require 'worklog/version'

require 'date'
require 'json'
require 'optparse'
require 'time'

module Worklog
  class Error < StandardError; end
  # Your code goes here...
end
