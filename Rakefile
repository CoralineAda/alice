require 'rake'
require 'bundler'
Dir.glob('tasks/*.rake').each { |r| import r }

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

# Run `rake -T` for the complete task list
#Alice::Tasks.new.define_tasks!