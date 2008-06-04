require "date"
require "fileutils"
require "rubygems"
require "rake/gempackagetask"

require "./lib/gemjour/version.rb"

gemjour_gemspec = Gem::Specification.new do |s|
  s.name             = "gemjour"
  s.version          = Gemjour::VERSION
  s.platform         = Gem::Platform::RUBY
  s.has_rdoc         = true
  s.extra_rdoc_files = ["README.rdoc"]
  s.summary          = "Advertise, list, and install gems over Bonjour."
  s.description      = s.summary
  s.authors          = ["Evan Phoenix"]
  s.email            = "evan@fallingsnow.net"
  s.homepage         = "http://github.com/evanphx/gemjour"
  s.require_path     = "lib"
  s.autorequire      = "gemjour"
  s.files            = %w(README.rdoc Rakefile) + Dir.glob("{bin,lib}/**/*")
  s.executables      = %w(gemjour)
  
  s.add_dependency "dnssd", ">= 0.6.0"
end

Rake::GemPackageTask.new(gemjour_gemspec) do |pkg|
  pkg.gem_spec = gemjour_gemspec
end

namespace :gem do
  namespace :spec do
    desc "Update gemjour.gemspec"
    task :generate do
      File.open("gemjour.gemspec", "w") do |f|
        f.puts(gemjour_gemspec.to_ruby)
      end
    end
  end
end

task :install => :package do
  sh %{sudo gem install pkg/gemjour-#{Gemjour::VERSION}}
end

desc "Remove all generated artifacts"
task :clean => :clobber_package
