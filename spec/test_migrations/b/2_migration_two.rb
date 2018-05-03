class MigrationTwo < ActiveRecord::Migration[5.0]
  def up
  end

  def down
    TestMigrations::Two.down
  end
end