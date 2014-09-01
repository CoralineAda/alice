require 'rubygems'
require 'rspec'
require_relative '../alice'

RSpec.configure do |config|
  config.before :each do
    Mongoid::Sessions.default.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
end