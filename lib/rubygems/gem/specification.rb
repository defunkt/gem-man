class Gem::Specification
  # Does this specification include a manpage?
  def has_manpage?(section = nil)
    manpages(section).any?
  end

  # Paths to the manpages included in this gem.
  def manpages(section = nil)
    @files.select do |file|
      file =~ /man\/(.+).#{section || '\d'}$/
    end
  end
end
