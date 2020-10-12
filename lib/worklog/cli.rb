# frozen_string_literal: true

module Worklog
  # command line interface
  class Cli
    def initialize
      @optparse = OptionParser.new
      @options = {}
      @worklog = Worklog.new

      define_options
    end

    attr_reader :options

    def main(argv = [])
      begin
        args = @optparse.parse(argv)
        parse_command(args.shift, args) unless @options[:no_command]
      rescue CommandArgumentError => e
        puts e.message
      rescue OptionParser::InvalidOption => e
        puts e.message
      end
      cleanup
    end

    def define_options
      @optparse.banner = <<~BANNER
        Track your time for work
        usage: worklog COMMAND [options]

        commands:
          done, d          Log your activity
          delete, del      Delete last day or last activity
          list, ls         Grouped output of work journal
          pause, p         Log your break
          start, s         Start your working day and specify the time ([HH[:MM])

        options:
      BANNER
      @optparse.version = VERSION
      @optparse.summary_indent = '  '

      @optparse.on('-d', '--duration [2h30m]', String, 'Specify the duration ([H]h[M]m)') do |duration|
        options[:duration] = duration
      end

      @optparse.on('-l', 'Detailed output for list') do
        options[:details] = true
      end

      @optparse.on('--full-day', 'Delete the active day') do
        options[:day] = true
      end

      @optparse.on('-o', '--overview', 'Outputs just the days for list') do
        options[:overview] = true
      end

      @optparse.on('-v', '--version', 'show version') do
        puts("Worklog Version #{VERSION}")
        @options[:no_command] = true
      end

      @optparse.on('-h', '--help', 'show help') do
        puts @optparse
        @options[:no_command] = true
      end
    end

    private

    # resets the options from last command
    def cleanup
      @options = {}
      @command = true
    end

    def parse_command(command, args)
      case command
      when 'start', 's'
        command_start(args)
      when 'delete', 'del'
        command_delete(args)
      when 'done', 'd'
        command_done(args)
      when 'pause', 'p'
        command_pause(args)
      when 'list', 'ls'
        command_list(args)
      when 'q', 'quit'
        puts('Bye bye')
        exit(0)
      when nil
        puts 'Know how this works? use -h for help'
      else
        puts '[INFO] Unknown command'
      end
    end

    def command_delete(args)
      params = delete_params(args)
      @worklog.delete(params)
      puts('Deleted')
    end

    def command_done(args)
      params = activity_params(args)
      activity = @worklog.log_activity(params)
      puts('Good Job! ' + activity.summary)
    end

    def command_list(args)
      params = list_params(args)
      @worklog.list(params)
    end

    def command_start(args)
      params = start_params(args)
      day = @worklog.create_day(params)
      puts('Good Morning!')
    end

    def command_pause(args)
      params = activity_params(args)
      pause = @worklog.log_pause(params)
      puts('Relax! ' + pause.summary)
    end

    def activity_params(args)
      params = {}
      raise CommandArgumentError, 'At least a text is required' if args.empty?

      # only one argument is allowed
      raise CommandArgumentError, 'Too many arguments' if args.length > 1

      if options[:duration]
        # has to be a valid duration argument
        unless Duration.valid_str?(options[:duration])
          raise CommandArgumentError, 'Invalid duration format'
        end

        params[:duration] = options[:duration]
      end

      params[:text] = args[0]
      params
    end

    def delete_params(args)
      # only zero argument is allowed
      raise CommandArgumentError, 'Too many arguments' unless args.empty?

      { day: options[:day] ? true : false }
    end

    def start_params(args)
      return {} if args.empty?

      # only one argument is allowed
      raise CommandArgumentError, 'Too many arguments' if args.length > 1
      # has to be a valid time argument
      unless Tools.correct_time_format?(args[0])
        raise CommandArgumentError, 'Invalid time format'
      end

      { start: Tools.parse_time(args[0]) }
    end

    def list_params(args)
      # only zero arguments are allowed
      raise CommandArgumentError, 'Too many arguments' if args.length.positive?

      {
        details: options[:details] ? true : false,
        overview: options[:overview] ? true : false
      }
    end
  end
end
