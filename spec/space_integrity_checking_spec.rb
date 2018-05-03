require "spec_helper"

RSpec.describe 'space integrity checking' do
  subject(:a){ DbMigrationSpace::Space.new :a, "#{SPEC}/test_migrations/a" }

  before {
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    DbMigrationSpace::SchemaMigrationBySpace.create_table
  }

  after { 
    ActiveRecord::Base.remove_connection
  }

  before {
    DbMigrationSpace::SchemaMigrationBySpace.create! version: '1', space: 'a'
    DbMigrationSpace::SchemaMigrationBySpace.create! version: '4', space: 'a'
    # create record for some other space to check that it will be ignored
    DbMigrationSpace::SchemaMigrationBySpace.create! version: '5', space: 'x'
  }

  context 'when all known and no extra space migrations recorded' do
    it { should be_consistent }
    its(:missing_migrations){ should be_empty }
    its(:extra_migrations){ should be_empty }
  end

  context 'when some space migrations are not recorded' do
    before {
      DbMigrationSpace::SchemaMigrationBySpace.where(version: '4').delete_all
    }

    it { should_not be_consistent }

    describe '#missing_migrations' do
      it 'contain missing migrations' do
        expect(a.missing_migrations).to eq [4]
      end
    end
  end

  context 'when some extra space migrations recorded' do
    before {
      DbMigrationSpace::SchemaMigrationBySpace.create! version: '6', space: 'a'
    }

    it { should_not be_consistent }

    describe '#extra_migrations' do
      it 'contain extra migrations' do
        expect(a.extra_migrations).to eq [6]
      end
    end
  end

  context 'when migrations table does not exist' do
    before { DbMigrationSpace::SchemaMigrationBySpace.drop_table }

    it 'does not fail' do
      should_not be_consistent
      expect(a.missing_migrations).to contain_exactly 1, 4
    end
  end

end