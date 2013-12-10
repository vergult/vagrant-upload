module VagrantPlugins
  module Upload
    class Config < Vagrant.plugin("2", :config)

      attr_accessor :files, :method

      def initialize
        @files = UNSET_VALUE
        @method = UNSET_VALUE
      end

      def finalize!
        @files = nil if @files == UNSET_VALUE
        case @method
        when UNSET_VALUE
          @method = :rsync
        when 'scp'
          @method = :scp
        else
          @method = :rsync
        end
      end

    end
  end
end
