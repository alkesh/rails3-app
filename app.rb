rvmrc = <<-RVMRC
rvm_gemset_create_on_use_flag=1
rvm gemset use #{app_name}
RVMRC

create_file ".rvmrc", rvmrc

gem "capybara", ">= 0.3.8", :group => [:test, :cucumber]
gem "cucumber-rails", ">= 0.3.2", :group => [:test, :cucumber]
gem "database_cleaner", ">= 0.5.2", :group => [:test, :cucumber]
gem "factory_girl_rails", ">= 1.0.0", :group => [:test, :cucumber]
gem "factory_girl_generator", ">= 0.0.1", :group => [:test, :cucumber, :development]
gem "rcov", ">= 0.9.8", :group => [:test]
gem "rspec-rails", ">= 2.0.0.beta.20", :group => [:test, :cucumber, :development]
gem "spork", ">= 0.8.4", :group => [:test, :cucumber]
gem "shoulda", :group => [:test]
gem "devise"
gem "inherited_resources", ">= 1.1.2"
gem "formtastic", "1.1.0.beta"

generators = <<-GENERATORS
    config.generators do |g|
      g.test_framework :rspec, :fixture => true, :views => false
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
      g.intergration_tool :rspec
    end
GENERATORS

application generators

get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js",  "public/javascripts/jquery.js"
get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jquery-ui.min.js", "public/javascripts/jquery-ui.js"
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"

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

defaultrake = %q(
Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end

Rake.application.remove_task('default')

task :default => [:'spec:rcov', :verify_rcov, :cucumber]

task :verify_rcov do
  total_coverage = 0

  File.open('coverage/index.html').each_line do |line|
    if line =~ /<tt class='coverage_total'>\s*(\d+\.\d+)%\s*<\/tt>/
      total_coverage = $1.to_f
      break
    end
  end
  puts "Coverage: #{total_coverage}%"
  raise "Coverage must be at least 100% but was #{total_coverage}%" if total_coverage < 100
end
)

rakefile 'default.rake', defaultrake

run 'bundle install'

generate 'rspec:install'
generate 'cucumber:install --rspec --capybara'

append_file ".gitignore", "coverage\n*.swp"
git :init
git :add => "."

