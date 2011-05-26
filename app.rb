say "Remove unwanted files"

remove_file "README"
remove_file "public/index.html"
remove_file "public/images/rails.png"

rvmrc = <<-RVMRC
rvm_gemset_create_on_use_flag=1
rvm gemset use #{app_name}
RVMRC

say "creating .rvmrc file"
create_file ".rvmrc", rvmrc

get "https://github.com/alkesh/rails3-app/raw/master/files/Gemfile", "Gemfile"

generators = <<-GENERATORS
    config.generators do |g|
      g.test_framework :rspec, :fixture => true, :views => false
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
      g.integration_tool :rspec
    end
GENERATORS

application generators

get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js",  "public/javascripts/jquery.js"
get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jquery-ui.min.js", "public/javascripts/jquery-ui.js"
get "https://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"

gsub_file 'config/application.rb', 'config.action_view.javascript_expansions[:defaults] = %w()', 'config.action_view.javascript_expansions[:defaults] = %w(jquery.js jquery-ui.js rails.js)'

layout = <<-LAYOUT
!!!
%html
  %head
    %title #{app_name.humanize}
    = stylesheet_link_tag :all
    = javascript_include_tag :defaults
    = csrf_meta_tag
  %body
    = yield
LAYOUT

create_file "log/.gitkeep"
create_file "tmp/.gitkeep"


get "https://github.com/alkesh/rails3-app/raw/master/default.rake", "lib/tasks/default.rake"
get "https://github.com/alkesh/rails3-app/raw/master/rspec.rake", "lib/tasks/rspec.rake"

append_file ".gitignore", "coverage\n*.swp\ndb/schema.rb\nTAGS\nconfig/environments/production.rb\nall.js\nall.css\nvendor/bundle"
git :init
git :add => "."

puts "Now run the following commands:"
puts "cd #{app_name}"
puts "gem install bundler"
puts "bundle install"
puts "rails g rspec:install"
puts "rails g cucumber:install --rspec --capybara"
puts "rake flutie:install"
