

module EntityFactory

  def self.activity(duration: '2h', topic: 'DEV')
      start = Time.parse('2001-02-03 04:05:06')
      text =  topic + ' doing'

      Worklog::Activity.new(start: start, duration: duration, text: text)
  end

  def self.day(start: DateTime.now)

    Worklog::Day.new(start: start)
  end

  def self.pause(duration: '2h')
    start = Time.parse('2001-02-03 04:05:06')

    Worklog::Pause.new(start: start, duration: duration)
  end
end
