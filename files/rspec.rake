begin
  desc "Run specs under rcov"
  RSpec::Core::RakeTask.new("spec_with_rcov") do |t|
    t.pattern = FileList["spec/**/*_spec.rb"]
    t.rcov = true
    t.rcov_opts = "--rails --exclude spec,factories,/gems/ --output #{ENV['CC_BUILD_ARTIFACTS']}/coverage"
  end
rescue NameError
  desc 'spec_with_rcov rake task not available (rspec not installed)'
  task :spec_with_rcov do
    abort 'spec_with_rcov rake task is not available. Be sure to install rspec as a gem or plugin'
  end
end
