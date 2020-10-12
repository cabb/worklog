# frozen_string_literal: true

RSpec.describe Worklog::Duration do
  let(:seconds) { 16_200 }

  let(:duration) do
    described_class.new(seconds: seconds)
  end

  describe '.new' do
    it 'creates an instance' do
      expect(described_class.new(seconds: 30)).not_to be_nil
    end
  end

  describe '.parse' do
    context 'valid duration string' do
      let(:duration_to_s) { '01h45m' }
      let(:duration) do
        described_class.parse(duration_to_s)
      end

      it 'creates an instance' do
        expect(duration).not_to be_nil
      end

      it 'parse the duration string' do
        expect(duration.seconds).to eq 6300
      end

      it 'represents the correct duration' do
        expect(duration.to_s).to eq duration_to_s
      end
    end

    context 'invalid duration string' do
      let(:duration_to_s) { '1h10mwft lol' }
      let(:duration) do
        described_class.parse(duration_to_s)
      end

      it 'creates an instance' do
        expect(duration).not_to be_nil
      end

      it 'parse only the valid duration parts' do
        expect(duration.seconds).to eq 4200
      end
    end
  end

  describe '.valid_str?' do
    context 'invalid duration string' do
      let(:str) { '2g' }
      it 'returns false' do
        expect(described_class.valid_str?(str)).to be_falsey
      end
    end

    context 'valid duration string' do
      let(:str) { '1000h40m' }
      it 'returns true' do
        expect(described_class.valid_str?(str)).to be_truthy
      end
    end
  end

  describe '#+' do
    context 'when the type is duration' do
      let(:duration2) do
        described_class.new(seconds: 800)
      end
      let(:new_duration) { duration + duration2 }

      it 'creates a new instance' do
        expect(new_duration).not_to be duration
        expect(new_duration).not_to be duration2
      end

      it 'adds the seconds' do
        expect(new_duration.seconds).to be 17_000
      end
    end

    context 'when the type is numeric' do
      let(:num2) { 50 }
      let(:new_duration) { duration + num2 }

      it 'creates a new instance' do
        expect(new_duration).not_to be duration
      end

      it 'adds the seconds' do
        expect(new_duration.seconds).to be 16_250
      end
    end
  end

  describe '#seconds' do
    it 'returns the amount of seconds' do
      expect(duration.seconds).to eq 16_200
    end
  end

  describe '#hours' do
    it 'returns the amount of hours' do
      expect(duration.hours).to eq 4
    end
  end

  describe '#minutes' do
    it 'returns the amount of minutes' do
      expect(duration.minutes).to eq 30
    end
  end

  describe '#to_sap_time_str' do
    it 'returns a time string (minutes to a base of 100)' do
      expect(duration.to_sap_time_str).to eq '04:50'
    end
  end

  describe '#to_time_str' do
    it 'returns a time string' do
      expect(duration.to_time_str).to eq '04:30'
    end
  end

  describe '#to_s' do
    it 'returns a duration string' do
      expect(duration.to_s).to eq '04h30m'
    end
  end
end
