# frozen_string_literal: true

RSpec.describe Worklog do
  describe '::VERSION' do
    it 'is defined' do
      expect(Worklog::VERSION).not_to be nil
    end

    it 'is sematic version number' do
      VERSION_REGEX = /^([0-9]+)\.([0-9]+)\.([0-9]+)$/.freeze
      expect(VERSION_REGEX.match?(Worklog::VERSION)).to be true
    end
  end
end
