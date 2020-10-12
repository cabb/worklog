# frozen_string_literal: true

# follow https://github.com/codica2/rspec-best-practices

RSpec.describe Worklog::Cli do
  let(:cli) { described_class.new }

  # avoid puts and print to stdout
  before do
    allow($stdout).to receive(:write)
  end

  describe '.new' do
    it 'no options are defined' do
      expect(cli.options.is_a?(Hash)).to be_truthy
      expect(cli.options.empty?).to be_truthy
    end
  end
end
