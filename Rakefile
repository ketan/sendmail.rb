#!/usr/bin/env rake

$:.unshift File.expand_path('../bundle', __FILE__)
$:.push File.expand_path("../lib", __FILE__)
require 'sendmail/version'

require 'rake/testtask'
require 'rake/clean'

begin
  require 'bundler/setup'
rescue LoadError
  $stderr.puts "Could not load bundler/setup. Please run 'bundle install --standalone --local --path bundle`"
end


CLEAN.include('pkg')

desc "Package the gem"
task :build => [:clean] do
  sh "gem build sendmail.gemspec -v"
  mkdir_p 'pkg'
  mv "sendmail-#{Sendmail::VERSION}.gem", 'pkg'
end

desc "install the gem"
task :install => :build do
  sh "gem install pkg/sendmail-#{Sendmail::VERSION}.gem"
end
