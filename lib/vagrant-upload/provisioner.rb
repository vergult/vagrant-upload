module VagrantPlugins
  module Upload
    class Provisioner < Vagrant.plugin("2", :provisioner)

      def provision
        config.files.each do |args|
          case config.method
          when :rsync
            command = rsync_cmd(args[:host], args[:guest])
          when :scp
            command = scp_cmd(args[:host], args[:guest])
          end
          @machine.env.ui.info command
          res = Vagrant::Util::Subprocess.execute(*command)
          if res.exit_code != 0
            raise Errors::UploadError,
                :guestpath => args[:guest],
                :hostpath  => args[:host],
                :stder     => res.stderr
          end
        end
      end

      private

      def rsync_cmd(host_path, guest_path)
        rsync_opts = "--rsync-path='sudo rsync'"
        ssh_opts   = ssh_common_opts.push("-l #{@machine.ssh_info[:username]}").join(' ')
        ["rsync","-av","--partial","#{rsync_opts}", "-e","'ssh #{ssh_opts}'",
                 "#{host_path}", "#{@machine.ssh_info[:host]}:#{guest_path}"]
      end

      def scp_cmd(host_path, guest_path)
        ["scp"] + ssh_common_opts +
        ["-r", "#{host_path}", "#{@machine.ssh_info[:username]}@#{@machine.ssh_info[:host]}:#{guest_path}"]
      end

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
