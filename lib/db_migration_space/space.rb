module DbMigrationSpace
  class Space
    attr_reader :name, :paths

    def initialize(name, paths)
      @name, @paths = name, paths
    end

    def consistent?
      missing_migrations.empty? && extra_migrations.empty?
    end

    def migrations
      if ActiveRecord::VERSION::STRING < '5.2'
        ActiveRecord::Migrator.migrations(@paths)
      else
        ActiveRecord::MigrationContext.new(@paths).migrations
      end
    end

    def missing_migrations
      defined_versions - get_all_versions
    end

    def extra_migrations
      get_all_versions - defined_versions
    end

    def get_all_versions
      if SchemaMigrationBySpace.table_exists?
        SchemaMigrationBySpace.where(space: @name).all.map{|x| x.version.to_i}.sort
      else
        []
      end
    end

    def include?(version)
      defined_versions.include?(version)
    end

    private

    def defined_versions
      migrations.map(&:version)
    end
  end
end