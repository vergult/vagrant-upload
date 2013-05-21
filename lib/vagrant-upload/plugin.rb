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
        require_relative 'provisioner'
        Provisioner
      end

    end

  end
end
