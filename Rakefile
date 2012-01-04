#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Segue::Application.load_tasks

namespace :resque do
  task :setup => :environment do
    Resque.workers.each do |worker|
      puts worker.to_s
    end
  end
end
