# frozen_string_literal: true

# follow https://github.com/codica2/rspec-best-practices

RSpec.describe Worklog::Loop do
  subject(:loop) { described_class.new }

  # avoid puts and print to stdout
  before do
    allow($stdout).to receive(:write)
  end

  describe '#to_argv' do
    it 'returns correct escaped string' do
      expect(loop.to_argv('done "long long text"')).to eq ['done', 'long long text']
    end

    it 'returns correct single parameter' do
      expect(loop.to_argv('done')).to eq ['done']
    end

    it 'handles empty input' do
      expect(loop.to_argv('')).to eq []
    end
  end

  describe '#user_input' do
    it 'reads the input' do
      allow(loop).to receive(:gets).and_return('done -d 30m "DEV testing"\n')
      input = loop.user_input
      expect(input).to eq('done -d 30m "DEV testing"\n')
    end

    it 'encodes the input to UTF-8' do
      allow(loop).to receive(:gets).and_return('öäü\n')
      input = loop.user_input
      expect(input.encoding.to_s).to eq 'UTF-8'
    end

    it 'reads correctly umlaute' do
      allow(loop).to receive(:gets).and_return('öäü\n')
      input = loop.user_input
      expect(input).to eq 'öäü\n'
    end
  end
end
