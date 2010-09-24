run "rm public/index.html"

file "Isolate", <<-END
gem "rails",        "3.0.0"
gem "haml",         "3.0.18"
gem "sqlite3-ruby", "1.3.1"

env :development do
  gem "thin",       "1.2.7"
  gem "haml-rails", "0.2"
end
END

run "rm config/boot.rb"
file "config/boot.rb", <<-END
require "rubygems"
require "isolate/now"
END

# Remove the lines that require bundler
application = File.read("config/application.rb")
run "rm config/application.rb"
file "config/application.rb", application.gsub(%r{(require 'rails/all').*(\n\nmodule)}m, '\1\2')

run "rm README"
file "README", <<-END
Install the `isolate` rubygem. Run `rake`. Follow the instructions. Enjoy.
END

run "rm config/database.yml"
file "config/database.yml", <<-END
development: &defaults
  adapter: sqlite3
  database: db/development.sqlite3
  pool: 5
  timeout: 5000

test: &test
  <<: *defaults
  database: ":memory:"

production:
  development
END

run "rm doc/README_FOR_APP"
file "doc/newb.txt", <<-END

  FINISHED. What I did for you:

    * Installed gems for development and testing.
    * Created DBs using SQLite and the stock database.yml.
    * Reset them with db/schema.rb.
    * Ran the tests.

END

routes = File.read("config/routes.rb")
run "rm config/routes.rb"
file "config/routes.rb", routes.gsub(%r{(.*\.routes\.draw do\n).*(end$)}m, '\1\2')

rakefile "newb.rake", <<-END
Rake::Task["default"].prerequisites.replace %w(newb) +
  Rake::Task["default"].prerequisites

task :newb do
  next unless Dir["log/*.log"].empty?
  puts "Looks like you're new here. Let's get crackin'."

  %w(db:create:all db:schema:dump test).each do |t|
    Rake::Task[t].invoke
  end

  puts IO.read(Rails.root.join("doc/newb.txt"))
end
END

rakefile "replacements.rake", <<-END
Rake::TaskManager.class_eval do # HACK
  def nuke(task_name)
    @tasks.delete task_name.to_s
  end
end

# Rails' default test task loads the environment three times. Once for
# units, once for functionals, and once for integration. This is
# faster. We also use an in-memory SQLite DB, so no
# db:test:prepare. See the top of test_helper.rb for the schema load.

Rake.application.nuke "test"

Rake::TestTask.new :test do |t|
  t.libs   << "test"
  t.pattern = "test/**/*_test.rb"
end

Rake::Task["test"].comment = "Run tests in memory DB."

doctasks = Rake.application.tasks.map(&:name).select { |n| /doc/ =~ n }
doctasks.each { |n| Rake.application.nuke n }
END

initializer "attr_accessible.rb", <<-END
# Force all models into using attr_accessible
class ActiveRecord::Base
  attr_accessible nil
end
END

run "rm test/performance/browsing_test.rb"
run "rm test/test_helper.rb"
run "mkdir test/support"
file "test/support/.gitkeep"
file "test/test_helper.rb", <<-END
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

silence_stream STDOUT do
  require File.expand_path('../../db/schema', __FILE__)
end

Dir[Rails.root.join("test/support/**/*.rb")].each do |helper|
  require helper
end
END

run "rm log/*"

rake "default"
readme "doc/newb.txt"

git "init"
git "add ."
git "commit -m 'F1RST PO5T!!!1!'"
