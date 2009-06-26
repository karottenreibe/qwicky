# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{qwicky}
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors =  ["Fabian Streitel"]
  s.date = %q{2009-06-15}
  s.description = %q{Qwicky is a REALLY small wiki implementation using Sinatra, DataMapper and SQLite3.}
  s.email = %q{karottenreibe@gmail.com}
  s.files = ["HISTORY.markdown", "README.markdown", "LICENSE.txt", "bin/qwicky", "qwicky.gemspec"]
  s.has_rdoc = false
  s.homepage = %q{http://github.com/karottenreibe/qwicky}
  s.rubygems_version = %q{1.3.0}
  s.summary = s.description
  s.executables = %w{qwicky}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>)
      s.add_runtime_dependency(%q<dm-aggregates>)
      s.add_runtime_dependency(%q<dm-validations>)
      s.add_runtime_dependency(%q<sinatra>)
      s.add_runtime_dependency(%q<haml>)
    else
      s.add_dependency(%q<dm-core>)
      s.add_dependency(%q<dm-aggregates>)
      s.add_dependency(%q<dm-validations>)
      s.add_dependency(%q<sinatra>)
      s.add_dependency(%q<haml>)
    end
  else
    s.add_dependency(%q<dm-core>)
    s.add_dependency(%q<dm-aggregates>)
    s.add_dependency(%q<dm-validations>)
    s.add_dependency(%q<sinatra>)
    s.add_dependency(%q<haml>)
  end
end

