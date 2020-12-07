# frozen_string_literal: true

# follow https://github.com/codica2/rspec-best-practices
# https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
RSpec.describe Worklog::Day do
  let(:start) { DateTime.now }

  let(:day) do
    EntityFactory.day(start: start)
  end

  describe '::new' do
    it 'creates a day class' do
      expect(day).to be_truthy
    end

    it 'has a start date' do
      expect(day.start).to eq start
    end

    it 'has no activities' do
      expect(day.activities).to be_empty
    end
  end

  describe '::compare' do
    let(:day1) { EntityFactory.day(start: Time.parse('2001-02-03 04:05:06')) }
    let(:day2) { EntityFactory.day(start: Time.parse('2001-02-03 04:05:07')) }

    it 'compares equal' do
      expect(day1).not_to eq(day2)
    end

    it 'compares greater and smaller than' do
      expect(day1).to be < day2
      expect(day1).not_to be > day2
    end
  end

  describe '#add' do
    let(:activity) { EntityFactory.activity }

    it 'adds activites' do
      expect(day.activities.length).to be 0
      day.add(activity)
      expect(day.activities.length).to be 1
    end
  end

  context 'with no activities' do
    let(:day) { EntityFactory.day(start: start) }

    describe '#end' do
      it 'returns start date' do
        expect(day.end).to eq day.start
      end
    end

    describe '#work_time' do
      it 'has 0 work time' do
        expect(day.work_time.seconds).to be 0
      end
    end

    describe '#pause_time' do
      it 'has 0 pause time' do
        expect(day.pause_time.seconds).to be 0
      end
    end
  end

  context 'with activities' do
    let(:day) { EntityFactory.day(start: start) }
    let(:default_duration) { '2h10m' }
    let(:test_topic) { 'TEST' }
    let(:dev_topic) { 'DEV' }
    let(:test_activity) { EntityFactory.activity(duration: default_duration, topic: test_topic) }
    let(:dev_activity) { EntityFactory.activity(duration: default_duration, topic: dev_topic) }
    let(:pause) { EntityFactory.pause(duration: default_duration) }

    let(:day_with_activities) do
      day.add(test_activity)
      day.add(test_activity)
      day.add(pause)
      day.add(dev_activity)

      day
    end

    describe '#work_time' do
      it 'calculates the working duration' do
        expect(day_with_activities.work_time.to_s).to eq '06h30m'
      end
    end

    describe '#end' do
      it 'returns end of the last activity' do
        expect(day_with_activities.end).to eq day.activities[-1].end
      end
    end

    describe '#pause_time' do
      it 'calculates the pause duration' do
        expect(day_with_activities.pause_time.to_s).to eq '02h10m'
      end
    end

    describe '#duration_by_topic' do
      let(:topics) { day_with_activities.duration_by_topic }

      it 'returns a hash' do
        expect(topics.is_a?(Hash)).to be true
      end

      it 'calculates total duration by topic' do
        expect(topics[test_topic][:duration].to_s).to eq '04h20m'
        expect(topics[dev_topic][:duration].to_s).to eq '02h10m'
      end

#      it 'calculates only work times' do
#        total = topics.values[:duration].to_i.inject(:+)
#
#        expect(total.to_s).to eq day_with_activities.work_time.to_s
#      end
    end
  end

  describe '.parse' do
    let(:log_hash) do
      {
        'start' => '2020-09-09 08:00:00',
        'activities' => [
          {
            'type' => 'A',
            'start' => '2020-09-09 08:00:00',
            'duration' => '00h40m',
            'text' => 'DEV OPS THemen'
          },
          {
            'type' => 'P',
            'start' => '2020-09-09 08:40:00',
            'duration' => '00h20m',
            'text' => 'Kaffe'
          }
        ]
      }.transform_keys(&:to_sym)
    end
    let(:parsed_day) { described_class.parse(log_hash) }

    it 'creates a new day instance' do
      expect(parsed_day.is_a?(described_class)).to be_truthy
    end

    it 'creates the activities' do
      expect(parsed_day.activities?).to be_truthy
      expect(parsed_day.activities.length).to eq 2
    end

    it 'creates the breaks' do
      expect(parsed_day.activities?).to be_truthy
      expect(parsed_day.breaks.length).to eq 1
    end
  end
end
