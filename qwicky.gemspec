# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{qwicky}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors =  ["Fabian Streitel"]
  s.date = %q{2009-06-15}
  s.description = %q{Qwicky is a REALLY small wiki implementation using Sinatra, DataMapper and SQLite3.}
  s.email = %q{karottenreibe@gmail.com}
  s.files = ["HISTORY.txt", "README.txt", "LICENSE.txt", "bin/qwicky"]
  s.has_rdoc = false
  s.homepage = %q{http://github.com/karottenreibe/qwicky}
  s.require_paths = []
  s.rubygems_version = %q{1.3.0}
  s.summary = s.description

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core dm-aggreates dm-validations sinatra haml>)
    else
      s.add_dependency(%q<dm-core dm-aggreates dm-validations sinatra haml>)
    end
  else
    s.add_dependency(%q<dm-core dm-aggreates dm-validations sinatra haml>)
  end
end

