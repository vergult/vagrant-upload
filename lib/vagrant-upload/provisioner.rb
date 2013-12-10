module VagrantPlugins
  module Upload
    class Provisioner < Vagrant.plugin("2", :provisioner)

      def provision
        config.files.each do |args|
        case config.method
        when :rsync
          @machine.env.ui.info rsync_cmd(args[:host], args[:guest])
          system rsync_cmd(args[:host], args[:guest])
        when :scp
          @machine.env.ui.info scp_cmd(args[:host], args[:guest])
          system scp_cmd(args[:host], args[:guest])
        end
        end
      end

      private

      def rsync_cmd(host_path, guest_path)
        rsync_opts = "--rsync-path='sudo rsync'"
        ssh_opts   =  "-i #{@machine.ssh_info[:private_key_path]} " <<
                      "-p #{@machine.ssh_info[:port]} " <<
                      "-l #{@machine.ssh_info[:username]} " <<
                      "-o StrictHostKeyChecking=no " <<
                      "-o UserKnownHostsFile=/dev/null " <<
                      "-o IdentitiesOnly=yes " <<
                      "-o LogLevel=ERROR"

        "rsync -av --partial #{rsync_opts} -e 'ssh #{ssh_opts}' #{host_path} #{@machine.ssh_info[:host]}:#{guest_path}"
      end

      def scp_cmd(host_path, guest_path)
        scp_opts   =  "-i #{@machine.ssh_info[:private_key_path]} " <<
                      "-p #{@machine.ssh_info[:port]} " <<
                      "-r" <<
                      "-o StrictHostKeyChecking=no " <<
                      "-o UserKnownHostsFile=/dev/null " <<
                      "-o IdentitiesOnly=yes " <<
                      "-o LogLevel=ERROR"

        "scp #{scp_opts} #{host_path} #{@machine.ssh_info[:username]}@#{@machine.ssh_info[:host]}:#{guest_path}"
      end

    end
  end
end
