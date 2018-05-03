module ActiveRecord
  module DbMigrationSpaceMigratorExtension
    def initialize(*args)
      super
      DbMigrationSpace::SchemaMigrationBySpace.create_table
    end

    private

    def record_version_state_after_migrating(version)
      super
      DbMigrationSpace.record_version_state(version, @direction)
    end
  end

  class Migrator
    prepend DbMigrationSpaceMigratorExtension
  end
end