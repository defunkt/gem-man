# Much of this is stolen from the `open_gem` RubyGem's "read"
# command.
#
# http://github.com/adamsanderson/open_gem/blob/dfddaa286e/lib/rubygems/commands/read_command.rb
class Gem::Commands::ManCommand < Gem::Command
  include Gem::VersionOption

  def initialize
    super 'man', "Open the gem's manpage or rdoc",
      :command => nil,
      :version => Gem::Requirement.default,
      :latest  => false

    add_latest_version_option
    add_version_option
    add_exact_match_option
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

  def arguments
    "GEMNAME       gem whose manpage you wanna read"
  end

  def execute
    # Grab our target gem.
    name = get_one_gem_name

    # Try to read manpages.
    read_manpage get_spec(name) { |s| s.has_manpage? }

    # Failed. Try to read rdoc via ri.
    read_rdoc get_spec(name) { |s| s.has_rdoc? }
  end

  def read_rdoc(spec)
    return unless path = get_path(spec)

    if File.exists?(path)
      read_gem(path)
    elsif ask_yes_no "No RDoc. Regenerate?", true
      generate_rdoc(spec)
      read_gem(path)
    end
  end

  def generate_rdoc(spec)
    Gem::DocManager.new(spec).generate_rdoc
  end

  def get_spec(name)
    dep = Gem::Dependency.new(name, options[:version])
    specs = Gem.source_index.search(dep)
    puts specs[0].class.inspect

    if block_given?
      specs = specs.select { |spec| yield spec}
    end

    if specs.length == 0
      # If we have not tried to do a pattern match yet, fall back on it.
      if !options[:exact] && !name.is_a?(Regexp)
        pattern = /#{Regexp.escape name}/
        get_spec(pattern)
      else
        say "#{name.inspect} is not available"
        nil
      end
    elsif specs.length == 1 || options[:latest]
      specs.last
    else
      choices = specs.map{|s|"#{s.name} #{s.version}"}
      c,i = choose_from_list "Open which gem?", choices
      specs[i] if i
    end
  end
end
