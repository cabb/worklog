# frozen_string_literal: true

RSpec.describe Worklog::Pause do
  let(:text) { 'breal' }

  let(:pause) do
    described_class.new(start: Time.now, duration: '6h', text: text)
  end

  describe '#pause?' do
    it 'returns true' do
      expect(pause.pause?).to be true
    end
  end

  describe '#text' do
    it 'returns the text' do
      expect(pause.text).to eq text
    end
  end

  describe '#topic' do
    it 'returns nil' do
      expect(pause.topic).to be_nil
    end
  end

  describe '#to_hash' do
    let(:hash) { pause.to_hash }

    it 'returns a hash' do
      hash.is_a?(Hash)
    end

    it 'has the TYPE P' do
      expect(hash[:type]).to eq 'P'
    end

    it 'has the correct duration' do
      expect(hash[:duration]).to eq '06h00m'
    end

    it 'has the correct text' do
      expect(hash[:text]).to eq text
    end
  end
end
