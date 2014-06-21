require 'rake'
require 'bundler'
require './alice'

Dir.glob('tasks/*.rake').each {|rakefile| import rakefile }

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
