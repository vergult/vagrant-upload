require "vagrant"

module VagrantPlugins
  module Upload
    module Errors
      class VagrantUploadError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_upload.errors")
      end

      class UploadError < VagrantUploadError
        error_key(:upload_error)
      end

    end
  end
end

