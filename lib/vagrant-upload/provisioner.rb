module VagrantPlugins
  module Upload
    class Provisioner < Vagrant.plugin("2", :provisioner)

      def provision
        config.files.each do |args|
          hostpath = File.expand_path(args[:host])
          hostfiles = Dir.glob(hostpath)
          case config.method
          when :rsync
            command = rsync_cmd(hostfiles, args[:guest])
          when :scp
            command = scp_cmd(hostfiles, args[:guest])
          end
          @machine.env.ui.info command
          res = Vagrant::Util::Subprocess.execute(*command)
          if res.exit_code != 0
            raise Upload::Errors::UploadError,
                :guestpath => args[:guest],
                :hostpath  => args[:host],
                :stder     => res.stderr
          end
        end
      end

      private

      # generate rsync command
      #
      # @argument host_files [Array]
      #           guest_path [String]
      # @return [Array]
      def rsync_cmd(host_files, guest_path)
        rsync_opts = "--rsync-path=sudo rsync"
        ssh_opts   = ssh_common_opts.push("-l #{@machine.ssh_info[:username]}").join(' ')
        ["rsync","-av","--partial","#{rsync_opts}", "-e","ssh #{ssh_opts}"] +
        host_files + ["#{@machine.ssh_info[:host]}:#{guest_path}"]
      end

      # generate scp command
      #
      # @argument host_files [Array]
      #           guest_path [String]
      # @return [Array]
      def scp_cmd(host_files, guest_path)
        ["scp"] + ssh_common_opts +
        ["-r"] + host_files +
        ["#{@machine.ssh_info[:username]}@#{@machine.ssh_info[:host]}:#{guest_path}"]
      end

      # return generic commmon ssh options
      #
      # @return [Array]
      def ssh_common_opts
        ["-i #{@machine.ssh_info[:private_key_path]}",
         "-p #{@machine.ssh_info[:port]}",
         "-o StrictHostKeyChecking=no",
         "-o UserKnownHostsFile=/dev/null",
         "-o IdentitiesOnly=yes",
         "-o LogLevel=ERROR"]
      end
    end
  end
end
