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

desc "Ship to GitHub pages"
task :pages => :build_man do
  `rm -rf htmls`
  mkdir "htmls"
  `cp man/*.html htmls`
  `git checkout gh-pages`
  `mv htmls/* .`
  rm_rf "htmls"
  `mv gem-man.1.html index.html`
  `git add .`
  `git commit -m updated`
  `git push origin gh-pages`
  `git checkout master`
  puts :done
end
