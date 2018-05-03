require "spec_helper"

RSpec.describe 'space integrity checking' do
  let(:path_a){ "#{SPEC}/test_migrations/a" }
  let(:path_b){ "#{SPEC}/test_migrations/b" }
  let(:path_c){ "#{SPEC}/test_migrations/c" }

  let(:migrations_paths){ [path_a, path_b, path_c] }

  let(:recorded_migrations){
    DbMigrationSpace::SchemaMigrationBySpace.all.map{|x|
      {version: x.version.to_i, space: x.space}
    }
  }

  before {
    DbMigrationSpace.create :a, path_a
    DbMigrationSpace.create :b, path_b
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    ActiveRecord::Migration.verbose = false
  }

  after { 
    DbMigrationSpace.class_eval{ @spaces = {} }
  }

  context 'running migrations' do
    context 'all' do
      specify 'all performed migrations are recorded for each space' do
        migrate
        expect(recorded_migrations).to contain_exactly(
          {version: 1, space: 'a'},
          {version: 2, space: 'b'},
          {version: 4, space: 'a'},
          {version: 5, space: 'b'}
        )
      end
    end

    context 'up to certain version' do
      specify 'all performed migrations are recorded for each space' do
        migrate 3
        expect(recorded_migrations).to contain_exactly(
          {version: 1, space: 'a'},
          {version: 2, space: 'b'}
        )
      end
    end

    context 'running certain version from some space' do
      specify 'performed migration is recorded for the space' do
        run :up, 4
        expect(recorded_migrations).to contain_exactly(
          {version: 4, space: 'a'}
        )
      end
    end

    context 'when some migration fails with exception' do
      specify 'all performed migrations are recorded for each space' do
        allow(TestMigrations::Four).to receive(:up).and_raise

        migrate rescue nil

        expect(recorded_migrations).to contain_exactly(
          {version: 1, space: 'a'},
          {version: 2, space: 'b'}
        )
      end
    end
  end

  context 'running down migrations' do
    before { migrate }

    context 'rollback' do
      specify 'all rolled back migrations are removed' do
        rollback 4

        expect(recorded_migrations).to contain_exactly(
          {version: 1, space: 'a'}
        )
      end
    end

    context 'moving down to certain version' do
      specify 'all rolled back migrations are removed' do
        migrate 3

        expect(recorded_migrations).to contain_exactly(
          {version: 1, space: 'a'},
          {version: 2, space: 'b'}
        )
      end
    end

    context 'rollback certain version from some space' do
      specify 'rolled back migration is removed' do
        run :down, 1

        expect(recorded_migrations).to contain_exactly(
          {version: 2, space: 'b'},
          {version: 4, space: 'a'},
          {version: 5, space: 'b'}
        )
      end
    end

    context 'when some migration rollback fails with exception' do
      specify 'all rolled back migrations are removed' do
        allow(TestMigrations::Two).to receive(:down).and_raise

        rollback 4 rescue nil

        expect(recorded_migrations).to contain_exactly(
          {version: 1, space: 'a'},
          {version: 2, space: 'b'}
        )
      end
    end
  end

  def migrate(target_version=nil)
    ActiveRecord::Migrator.migrate migrations_paths, target_version
  end

  def run(direction, target_version=nil)
    ActiveRecord::Migrator.run direction, migrations_paths, target_version
  end

  def rollback(steps=1)
    ActiveRecord::Migrator.rollback migrations_paths, steps
  end
end