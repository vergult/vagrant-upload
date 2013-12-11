begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant Upload plugin must be run within Vagrant."
end

if Vagrant::VERSION < "1.2.0"
  raise "The Vagrant Upload plugin is only compatible with Vagrant 1.2+"
end

module VagrantPlugins
  module Upload

    class Plugin < Vagrant.plugin('2')
      name 'Upload'

      description <<-DESC
      This plugin installs an upload provisioner that allows Vagrant to sync
      files between host and guest.
      DESC

      config(:upload, :provisioner) do
        require_relative 'config'
        Config
      end

      provisioner(:upload) do
        setup_i18n
        require_relative 'provisioner'
        Provisioner
      end

      # This initializes the internationalization strings.
      def self.setup_i18n
        I18n.load_path << File.expand_path("locales/en.yml", Upload.source_root)
        I18n.reload!
      end

    end

  end
end
