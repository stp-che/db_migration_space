module DbSeed
  module Rails
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load "tasks/db_migration_space.rake"
      end
    end
  end
end