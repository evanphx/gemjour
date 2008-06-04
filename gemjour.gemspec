Gem::Specification.new do |s|
  s.name = %q{gemjour}
  s.version = "1.0.0"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Evan Phoenix"]
  s.autorequire = %q{gemjour}
  s.date = %q{2008-06-03}
  s.default_executable = %q{gemjour}
  s.description = %q{Advertise, list, and install gems over Bonjour.}
  s.email = %q{evan@fallingsnow.net}
  s.executables = ["gemjour"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "bin/gemjour", "lib/gemjour", "lib/gemjour/version.rb", "lib/gemjour.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/evanphx/gemjour}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{Advertise, list, and install gems over Bonjour.}

  s.add_dependency(%q<dnssd>, [">= 0.6.0"])
end
