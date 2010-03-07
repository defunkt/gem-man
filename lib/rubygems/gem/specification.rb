class Gem::Specification
  # Does this specification include a manpage?
  def has_manpage?
    manpages.any?
  end

  # Paths to the manpages included in this gem.
  def manpages
    @files.select do |file|
      file =~ /man\/(.+).\d$/
    end
  end
end
