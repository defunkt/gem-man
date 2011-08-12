class Gem::Specification

  ##
  # Returns the full path to installed gem's manual directory.

  def man_dir
    @man_dir ||= File.join(respond_to?(:gem_dir) ? gem_dir : full_gem_path, 'man')
  end

  ##
  # Does this specification include a manpage?

  def has_manpage?(section = nil)
    File.directory?(man_dir) && manpages(section).any?
  end

  ##
  # Paths to the manpages included in this gem.

  def manpages(section = nil)
    Dir.entries(man_dir).select do |file|
      file =~ /(.+).#{section || '\d'}$/
    end
  end
end
