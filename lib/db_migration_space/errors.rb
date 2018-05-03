module DbMigrationSpace
  class Error < StandardError; end

  class SpaceNameDuplicationError < Error
    def initialize(space_name)
      super "space #{space_name.inspect} already exists"
    end
  end

  class SpaceNotFoundError < Error
    def initialize(space_name)
      super "space #{space_name.inspect} not found"
    end
  end
end