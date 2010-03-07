desc "Build the manual"
task :build_man do
  sh "ron -br5 --organization=DEFUNKT --manual='RubyGems Manual' man/*.ron"
end

desc "Show the manual"
task :man => :build_man do
  exec "man man/gem-man.1"
end

begin
  require 'mg'
  MG.new('gem-man.gemspec')
rescue Loaderror
  warn "gem install mg to get gem tasks"
end
