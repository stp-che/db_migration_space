require "spec_helper"

RSpec.describe 'space declaration' do
  after{ DbMigrationSpace.class_eval{ @spaces = {} } }

  describe 'DbMigrationSpace.create' do
    it 'creates space with given params' do
      space = DbMigrationSpace.create 'my_space', 'path1', 'path2'
      expect(space.name).to eq 'my_space'
      expect(space.paths).to eq ['path1', 'path2']
    end

    it 'checks uniqueness of space name' do
      DbMigrationSpace.create 'my_space', 'path1'
      expect{
        DbMigrationSpace.create 'my_space', 'path2'
      }.to raise_error DbMigrationSpace::SpaceNameDuplicationError
      expect{
        DbMigrationSpace.create :my_space, 'path2'
      }.to raise_error DbMigrationSpace::SpaceNameDuplicationError
    end
  end

  describe 'DbMigrationSpace.get' do
    it 'returns space by name' do
      space = DbMigrationSpace.create :my_space, 'path1', 'path2'
      expect(DbMigrationSpace.get('my_space')).to eq space
      expect(DbMigrationSpace.get(:my_space)).to eq space
    end

    context 'when space does not exist' do
      it 'raises SpaceNotFoundError' do
        expect{
          DbMigrationSpace.get 'a'
        }.to raise_error DbMigrationSpace::SpaceNotFoundError
      end
    end
  end
end
