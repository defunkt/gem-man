Gem::Specification.new do |s|
  s.name              = "gem-man"
  s.version           = "0.3.0"
  s.date              = "2011-08-15"
  s.summary           = "View a gem's man page."
  s.homepage          = "https://github.com/defunkt/gem-man"
  s.email             = "chris@ozmm.org"
  s.authors           = [ "Chris Wanstrath" ]

  s.files             = Dir.glob("{bin,lib,man}/**/*") + %w( README.md Rakefile LICENSE )

  s.description       = <<desc
  The `gem man` command can be used to display a man page for an
  installed RubyGem. The man page must be included with the gem -
  `gem-man` does no generation or magic.

  For an introduction to man pages, see `man(1)` (or type `man man` in
  your shell).
desc
end
