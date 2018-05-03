module DbMigrationSpace
  class SchemaMigrationBySpace < ActiveRecord::Base
    TABLE_NAME = 'schema_migrations__by_space'
    INDEX_NAME = 'sch_mgr_space_idx'

    class << self
      def create_table
        unless table_exists?
          connection.create_table(table_name, id: false) do |t|
            t.column :version, :string
            t.column :space, :string
          end
          connection.add_index table_name, [:version, :space], unique: true, name: index_name
        end
      end

      def drop_table
        if table_exists?
          connection.remove_index table_name, name: index_name
          connection.drop_table(table_name)
        end
      end

      def table_exists?
        connection.table_exists?(table_name)
      end

      def index_name
        "#{table_name_prefix}unique_#{INDEX_NAME}#{table_name_suffix}"
      end

      def table_name
        "#{table_name_prefix}#{TABLE_NAME}#{table_name_suffix}"
      end
    end
  end
end