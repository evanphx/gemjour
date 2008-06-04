$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "dnssd"
require "set"
require "gemjour/version"

Thread.abort_on_exception = true

module Gemjour
  Server  = Struct.new(:name, :host, :port)
  PORT    = 8808
  SERVICE = "_rubygems._tcp"

  def self.usage
    puts <<-HELP
Usage:

serve [<name>] [<port>]
  Start up a gem server as <name> on <port>. <name> is your username
  by default, and <port> is 8088. If you want to use the default <name>,
  pass it as "".

install <server> <gem>
  Installs <gem> from <server>. <server> is the name the server announces
  itself as.

list
  List all available gem servers.

show <server>
  List all gems available from <server>

    HELP
  end

  def self.find(name)
    host = nil

    waiting = Thread.current

    service = DNSSD.browse(SERVICE) do |reply|
      if name === reply.name
        DNSSD.resolve(reply.name, reply.type, reply.domain) do |rr|
          host = Server.new(reply.name, rr.target, rr.port)
          waiting.run
        end
      end
    end

    sleep 5
    service.stop

    host
  end

  def self.list(name = nil)
    return show(name) if name
    hosts = []

    waiting = Thread.current

    service = DNSSD.browse(SERVICE) do |reply|
      DNSSD.resolve(reply.name, reply.type, reply.domain) do |rr|
        host = Server.new(reply.name, rr.target, rr.port)
        unless hosts.include? host
          puts "#{host.name} (#{host.host}:#{host.port})"
          hosts << host
        end
      end
    end

    sleep 5
    service.stop
  end

  def self.show(name)
    host = find(name)

    unless host
      puts "ERROR: Unable to find server '#{name}'"
      return
    end

    system "gem list -r --source=http://#{host.host}:#{host.port}"
  end
  
  def self._diff(name)
    host = find(name)

    unless host
      puts "ERROR: Unable to find server named '#{name}'"
      return
    end
    
    require "tempfile"
    local_gems, remote_gems = Tempfile.new("local_gems"), Tempfile.new("remote_gems")
    local_gems.print(`gem list --no-versions --no-verbose`)
    local_gems.close
    remote_gems.print(`gem list --no-versions --no-verbose -r --source=http://#{host.host}:#{host.port}`)
    remote_gems.close
    `diff -u #{local_gems.path} #{remote_gems.path}`
  end

  def self.diff(name)
    puts _diff(name)
  end
  
  def self.install_diff(name)
    gem_diff = _diff(name)
    return unless gem_diff
    gem_diff.scan(/^\+([\w_\-]+)/) do |match|
      install(name, match)
    end
  end

  def self.install(name, gem)
    host = find(name)

    unless host
      puts "ERROR: Unable to find server named '#{user}'"
      return
    end

    puts "Installing gem '#{gem}' from #{host.host}:#{host.port}"
    system "gem install #{gem} -s http://#{host.host}:#{host.port}"
  end

  def self.serve(name="", port=PORT)
    name = ENV['USER'] if name.empty?

    tr = DNSSD::TextRecord.new
    tr['description'] = "#{name}'s gem server"
    
    DNSSD.register(name, SERVICE, "local", port, tr.encode) do |reply|
      puts "Serving gems under name '#{name}'..."
    end

    system "gem server --port=#{port} -q > /dev/null 2>&1"
  end

end
