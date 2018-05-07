require 'active_record'

require 'active_record/db_migration_space_extension'
require "db_migration_space/version"
require "db_migration_space/errors"
require "db_migration_space/space"
require "db_migration_space/schema_migration_by_space"

module DbMigrationSpace
  # @param [String]  name
  # @param [String]  *paths
  # @return [Space]
  def DbMigrationSpace.create(name, *paths)
    name = name.to_s
    raise SpaceNameDuplicationError.new(name) if @spaces[name]
    @spaces[name] = Space.new(name, paths)
  end

  # @param [String]  name
  # @return [Space]
  def DbMigrationSpace.get(name)
    name = name.to_s
    @spaces[name] || raise(SpaceNotFoundError.new(name))
  end

  # @param [Fixnum]  version
  # @param [Symbol]  direction  (:up or :down)
  def DbMigrationSpace.record_version_state(version, direction)
    if space = @spaces.values.find{|s| s.include?(version)}
      if direction == :down
        SchemaMigrationBySpace.where(version: version.to_s).delete_all
      else
        SchemaMigrationBySpace.create! version: version, space: space.name
      end
    end
  end

  def DbMigrationSpace.rebuild_index
    all_versions = if ActiveRecord::VERSION::STRING < '5.2'
      ActiveRecord::Migrator.get_all_versions
    else
      ActiveRecord::MigrationContext.new([]).get_all_versions
    end
    SchemaMigrationBySpace.create_table
    ActiveRecord::Base.transaction do
      SchemaMigrationBySpace.delete_all
      @spaces.values.each do |space|
        (space.defined_versions & all_versions).each do |version|
          SchemaMigrationBySpace.create! version: version, space: space.name
        end
      end
    end
  end

  @spaces = {}
end

require "db_migration_space/railtie" if defined?(::Rails)