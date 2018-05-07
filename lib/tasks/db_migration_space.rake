namespace :db do

  namespace :migration_space do
    desc "Rebuild migrations space index"
    task :update => [:environment, "db:load_config"] do
      DbMigrationSpace.rebuild_index
    end
  end

end