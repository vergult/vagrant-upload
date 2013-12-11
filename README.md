# Vagrant Upload Provisioner

This is a Vagrant 1.2+ plugin that adds an Upload provisioner to Vagrant,
allowing you to provide files to your guest via rsync.

Can be handy when you need to transfer files before applying another provisioner.
E.g.: When you need to transfer puppet certificates to your guest before
appying puppet server provisionning.

*NOTE:* This plugin requires Vagrant 1.2+

## Installation

```
$ vagrant plugin install vagrant-upload
```

## Usage

```ruby
Vagrant.configure("2") do |config|

  config.vm.box = "box"

  config.vm.provision :upload do |upload|
    upload.files = [{
      host: '~/.bin/*',
      guest: '/home/username/.bin'
    }]
    upload.method = :rsync
  end
end
```

## Configuration

This provisioner exposes one option:

* `files` - An array of hashes which specifies which host files you want to
  transfer to the guest like shown in the Usage example.
* `method` - method to use to upload files. Now you can use `rsync` and `scp`.
  Default: rsync

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
