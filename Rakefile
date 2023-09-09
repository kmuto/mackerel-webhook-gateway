require 'bundler/gem_tasks'
require 'rake/testtask'
require 'fileutils'

desc 'Check with rubocop'
task :rubocop do
  begin
    require 'rubocop/rake_task'
    RuboCop::RakeTask.new
  rescue LoadError
    $stderr.puts 'rubocop not found'
  end
end

task default: %i[rubocop]
