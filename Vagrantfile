VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define 'saltmaster' do |saltmaster|

    if Vagrant.has_plugin?('vagrant-proxyconf')
      saltminion.proxy.http = 'http://xxx.xxx.xxx.xxx:8080'
      saltminion.proxy.https = 'http://xxx.xxx.xxx.xxx:8080'
      saltminion.proxy.no_proxy = 'localhost,127.0.0.1,172.28.128.18,172.28.128.19'
      saltminion.yum_proxy.http = 'http://xxx.xxx.xxx.xxx:8080'
      saltminion.apt_proxy.http = 'http://xxx.xxx.xxx.xxx:8080'
      saltminion.apt_proxy.https = 'http://xxx.xxx.xxx.xxx:8080'
    end

    saltmaster.vm.network 'private_network', ip: '172.28.128.18'

    saltmaster.vm.hostname = 'saltmaster.net'
    saltmaster.vm.box = 'bento/centos-7.3'

    saltmaster.vm.provider 'virtualbox' do |v|
       v.memory = 1024
    end

    saltmaster.vm.provision "shell", path: "scripts/saltmaster.sh"
  end

  config.vm.define 'saltminion' do |saltminion|

    if Vagrant.has_plugin?('vagrant-proxyconf')
       saltminion.proxy.http = 'http://xxx.xxx.xxx.xxx:8080'
       saltminion.proxy.https = 'http://xxx.xxx.xxx.xxx:8080'
       saltminion.proxy.no_proxy = 'localhost,127.0.0.1,172.28.128.18,172.28.128.19'
       saltminion.yum_proxy.http = 'http://xxx.xxx.xxx.xxx:8080'
       saltminion.apt_proxy.http = 'http://xxx.xxx.xxx.xxx:8080'
       saltminion.apt_proxy.https = 'http://xxx.xxx.xxx.xxx:8080'
    end

    saltminion.vm.network 'private_network', ip: '172.28.128.19'

    saltminion.vm.hostname = 'saltminion.net'
    saltminion.vm.box = 'bento/centos-7.3'

    saltminion.vm.provider 'virtualbox' do |v|
       v.memory = 1024
    end

    saltminion.vm.provision "shell", path: "scripts/saltminion.sh"
  end
end
