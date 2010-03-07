require 'rubygems/command_manager'
require 'rubygems/gem/specification'

require 'ron'

# require 'rubygems/command'
# require 'rubygems/dependency'
# require 'rubygems/version_option'

Gem::CommandManager.instance.register_command :man
