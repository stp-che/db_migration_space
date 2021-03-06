# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "db_migration_space/version"

Gem::Specification.new do |spec|
  spec.name          = "db_migration_space"
  spec.version       = DbMigrationSpace::VERSION
  spec.authors       = ["schebannyj"]
  spec.email         = ["stp.eternal@gmail.com"]

  spec.summary       = %q{Declare migrations spaces and check status within them}
  spec.description   = %q{Declare migrations spaces and check status within them}
  spec.homepage      = "https://github.com/stp-che/db_migration_space"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activerecord", ENV['MSP_AR_VERSION'] || "~> 5.0"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "sqlite3"
end
