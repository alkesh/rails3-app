require 'rake/clean'

Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end

Rake.application.remove_task('default')

CLEAN.include %w(log/** tmp/** coverage)

ENV['CC_BUILD_ARTIFACTS'] ||= File.expand_path("#{Rails.root.to_s}/log")

task :default => [:clean, :'db:migrate', :'db:test:prepare', :'spec_with_rcov', :verify_rcov, :"cucumber", :ok]

task :verify_rcov do
  total_coverage = 0
  if File.exists?('coverage')
    File.open('coverage/index.html').each_line do |line|
      if line =~ /<tt class='coverage_total'>\s*(\d+\.\d+)%\s*<\/tt>/
        total_coverage = $1.to_f
        break
      end
    end
    puts "Coverage: #{total_coverage}%"
    raise "Coverage must be at least 100% but was #{total_coverage}%" if total_coverage < 100
  end
end

task :cruise => :default

task :ok do
  red    = "\e[31m"
  yellow = "\e[33m"
  green  = "\e[32m"
  blue   = "\e[34m"
  purple = "\e[35m"
  bold   = "\e[1m"
  normal = "\e[0m"
  puts "", "#{bold}#{red}*#{yellow}*#{green}*#{blue}*#{purple}* #{green} ALL TESTS PASSED #{purple}*#{blue}*#{green}*#{yellow}*#{red}*#{normal}"
end
