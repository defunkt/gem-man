# Much of this is stolen from the `open_gem` RubyGem's "read"
# command - thanks Adam!
#
# http://github.com/adamsanderson/open_gem/blob/dfddaa286e/lib/rubygems/commands/read_command.rb
class Gem::Commands::ManCommand < Gem::Command
  include Gem::VersionOption

  def initialize
    super 'man', "Open a gem's manual",
      :command => nil,
      :version => Gem::Requirement.default,
      :latest  => false,
      :all     => false

    add_all_gems_option
    add_system_fallback_option
    add_latest_version_option
    add_version_option
    add_exact_match_option
  end

  def usage
    "gem man [SECTION] GEMNAME"
  end

  def arguments
    "SECTION       section of the manual to search\n" +
    "GEMNAME       gem whose manual you wish to read"
  end

  def add_all_gems_option
    add_option('-a', '--all',
      'List all installed gems that have manuals.') do |value, options|
      options[:all] = true
    end
  end

  def add_system_fallback_option
    add_option('-s', '--system',
      'Falls back to searching for system-wide man pages.') do |value, options|
      options[:system] = true
    end
  end

  def add_latest_version_option
    add_option('-l', '--latest',
      'If there are multiple versions, open the latest') do |value, options|
      options[:latest] = true
    end
  end

  def add_exact_match_option
    add_option('-x', '--exact', 'Only list exact matches') do |value, options|
      options[:exact] = true
    end
  end

  def execute
    if get_one_optional_argument =~ /^\d$/
      section = get_one_optional_argument
    end

    if options[:all]
      puts "These gems have man pages:", ''

      specs = Gem::Specification.respond_to?(:each) ? Gem::Specification : Gem.source_index.gems
      specs.each do |*name_and_spec|
        spec = name_and_spec.pop
        puts "#{spec.name} #{spec.version}" if spec.has_manpage?
      end
    else
      # gem man 1 mustache
      section, name, _ = options[:args]

      if name.nil?
        # gem man mustache
        name, section = section, nil
      end

      # Try to read manpages.
      if spec = get_spec(name) { |s| s.has_manpage?(section) }
        read_manpage(spec, section)
      elsif options[:system]
        exec "man #{section} #{name}"
      else
        abort "No manual entry for #{name}"
      end
    end
  end

  def read_manpage(spec, section = nil)
    return if spec.nil?

    paths = spec.manpages(section)
    return if paths.empty?

    # man/ron.1 => ron(1)
    names = paths.map do |path|
      path.sub(/.*\/(.+)\.(\d+)/, '\1(\2)')
    end

    if paths.size == 1
      manpath = paths[0]
    elsif paths.size > 1
      name, index = choose_from_list("View which manual?", names)
      manpath = paths[index]
    end

    if manpath
      exec "man #{File.join(spec.man_dir, manpath)}"
    else
      abort "no manuals found for #{spec.name}"
    end
  end

  def gem_path(spec)
    File.join(spec.installation_path, "gems", spec.full_name)
  end

  def get_spec(name, &block)
    # Since Gem::Dependency.new doesn't want a Regexp
    # We'll do it ourself!
    specs = if Gem::Specification.respond_to?(:each)
      Gem::Specification.each.select { |spec| name === spec.name }
    else
      Gem.source_index.search Gem::Dependency.new(name, options[:version])
    end

    if block
      specs = specs.select { |spec| yield spec }
    end

    if specs.size.zero?
      # If we have not tried to do a pattern match yet, fall back on it.
      if !options[:exact] && !name.is_a?(Regexp)
        pattern = /#{Regexp.escape name}/
        get_spec(pattern, &block)
      else
        nil
      end
    elsif specs.size == 1 || options[:latest]
      specs.last
    else
      choices = specs.map { |s| "#{s.name} #{s.version}" }
      c, i = choose_from_list "Open which gem?", choices
      specs[i] if i
    end
  end
end
