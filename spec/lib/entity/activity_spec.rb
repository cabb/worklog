# frozen_string_literal: true

# follow https://github.com/codica2/rspec-best-practices
RSpec.describe Worklog::Activity do
  let(:text) { 'unit testing' }
  let(:topic) { 'DEV' }
  let(:start) { Time.now }
  let(:duration) { '6h' }

  let(:act) do
    described_class.new(start: start, duration: duration, text: topic + ' ' + text)
  end

  describe '#pause?' do
    it 'returns false' do
      expect(act.pause?).to be false
    end
  end

  describe '#text' do
    it 'returns the text' do
      expect(act.text).to eq text
    end
  end

  describe '#topic' do
    it 'returns the topic' do
      expect(act.topic).to eq topic
    end
  end

  describe '#to_hash' do
    let(:hash) { act.to_hash }

    it 'returns a has' do
      hash.is_a?(Hash)
    end

    it 'has the TYPE A' do
      expect(hash[:type]).to eq 'A'
    end

    it 'has the correct duration' do
      expect(hash[:duration]).to eq '06h00m'
    end

    it 'has the correct text' do
      expect(hash[:text]).to eq topic + ' ' + text
    end
  end

  describe '#parse_text' do
    it 'parses topic and text' do
      expect(act.parse_text('TEST super test')).to eq ['TEST', 'super test']
      expect(act.parse_text('BSE-423 super test')).to eq ['BSE-423', 'super test']
    end

    it 'parses only topics with space' do
      expect(act.parse_text('SUper test')).to eq [nil, 'SUper test']
      expect(act.parse_text('super test')).to eq [nil, 'super test']
    end

    it 'parses a string without spaces as text' do
      expect(act.parse_text('TEST')).to eq [nil, 'TEST']
      expect(act.parse_text('test')).to eq [nil, 'test']
    end
  end
end
