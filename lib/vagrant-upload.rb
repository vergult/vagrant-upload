require 'vagrant-upload/plugin'
require 'pathname'

module VagrantPlugins
  module Upload
    lib_path = Pathname.new(File.expand_path('../vagrant-upload', __FILE__))
    autoload :Errors, lib_path.join('errors')

    # This returns the path to the source of this plugin.
    #
    # @return [Pathname]
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end
  end
end
