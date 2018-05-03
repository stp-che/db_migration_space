class MigrationFour < ActiveRecord::Migration[5.0]
  def up
    TestMigrations::Four.up
  end

  def down
    
  end
end