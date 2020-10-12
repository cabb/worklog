# frozen_string_literal: true

require 'bundler/setup'
require 'worklog'

require 'byebug'

require_relative 'factories/entity_factory'

# Metaprogrammatical magic to temporarily expose a Class' privates (methods).
# rubocop:disable
class Class
  def publicize_methods
    saved_private_instance_methods = private_instance_methods
    class_eval { public *saved_private_instance_methods }
    yield
    class_eval { private *saved_private_instance_methods }
  end
end
# rubocop:enable

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
