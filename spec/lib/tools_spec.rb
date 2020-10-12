# frozen_string_literal: true

# follow https://github.com/codica2/rspec-best-practices
RSpec.describe Worklog::Tools do
  using described_class

  context 'Integeter' do
    describe '#to_duration' do
      let(:duration) { 300.to_duration }
      it 'converts to a Duration' do
        expect( duration.is_a?(Worklog::Duration) ).to be_truthy
        expect( duration.seconds ).to eq 300
      end
    end
  end


end
