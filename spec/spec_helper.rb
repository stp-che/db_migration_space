require "bundler/setup"
require "db_migration_space"
require "rspec/its"
require 'sqlite3'

SPEC = File.expand_path('..', __FILE__)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end


# hooks for the test migrations
module TestMigrations
  class Two
    def self.down; end
  end

  class Four
    def self.up; end
  end
end