# frozen_string_literal: true

require 'tempfile'

RSpec.describe Worklog::Worklog do
  let(:test_file) do
    file = Tempfile.new
    file << Worklog::LogFile::DEFAULT_CONTENT.to_json
    file.flush
    file
  end

  let(:worklog) { described_class.new(test_file.path) }

  # avoid puts and print to stdout
  before do
    allow($stdout).to receive(:write)
  end

  after do
    test_file.unlink
  end

  describe '#create_day' do
    let(:create_day) { worklog.create_day }
    let(:stored_day) { Worklog::Day.parse(worklog.log.active_day) }

    it 'stores a day to log and it can be read' do
      expect(create_day.end.to_s).to eq stored_day.end.to_s
      expect(create_day.activities).to eq stored_day.activities
    end

    it 'creates a new day' do
      expect(create_day.is_a?(Worklog::Day)).to be_truthy
    end
  end
end
