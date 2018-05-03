# DbMigrationSpace

Suppose you have two applications App1 and App2 integrated together using common database. One application (let's say App1) is a master, where you create and run your DB migrations. The other application (App2) uses some tables of App1 without creating or changing them.

Developing App2 independently on App1 you may want to check if actual DB schema satisfies business logic implemented in App2.

One of the approaches of implementing such a chek includes two questions one needs to answer:

1. Is DB schema outated? (Does App2 expect some changes to be made in common tables but corresponding migrations haven't been performed from App1?)
2. Is App2 outdated? (Are there any changes made in common tables that App2 does not know about?)

Gem `DbMigrationSpace` supplies a simple mechanism for answering these two questions **but** is demands a special way of organising DB migrations (see Usage).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'db_migration_space'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install db_migration_space

## Usage

### Organising migrations

In order to use `DbMigrationSpace` gem one have to organise DB migrations in a way that conforms following principles:

1. **Defining migration space**

  Define a part of data model that will be shared among several applications. Normally this part will be defined by a subset of tables and include everything else that concerns these tables: indexes, foregin keys, etc.
  
  Defining such part of data one defines a "migration space" that will include all the changes made with elements of this part.

  It is possible to have more than one migrations spaces.

2. **One migration - one space**
  
  All changes described in a migration file should belong to one migration space.

3. **Migrations separation**
  
  Place all migrations belonged to a certain migrations space in a separate folder so that each folder would not contain migrations from different spaces.

4. **Common migrations**

  Share migrations from a common space between applications. (For example, one can moving these migrations to a separate gem and include the gem to applications.)

### Migrations space declaration

```ruby
  DbMigrationSpace.create :my_space, "db/migrations/my_space"
```

### Checking migrations space integrity

```ruby
  my_space = DbMigrationSpace.get :my_space
  my_space.missing_migrations           # => list of migrations versions that haven't been performed yet
  my_space.missing_migrations.present?  # => answer for the question "Is DB schema outated?"
  my_space.extra_migrations             # => list of migrations versions that performed in DB but absent in a migrations folder
  my_space.extra_migrations.present?    # => answer for the question "Is application outdated?"

  my_space.consistent?                  # => true if neither missing nor extra migrations are present
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stp-che/db_migration_space.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
