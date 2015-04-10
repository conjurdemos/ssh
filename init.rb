#!/opt/conjur/embedded/bin/ruby
require 'conjur/cli'

Conjur::Config.load
Conjur::Config.apply

File.write 'conjur.conf', <<-CONF
account: #{Conjur.configuration.account}
appliance_url: #{Conjur.configuration.appliance_url}
cert_file: /etc/conjur-#{Conjur.configuration.account}.pem
netrc_path: /etc/conjur.identity
CONF
File.write "conjur-#{Conjur.configuration.account}.pem", File.read(Conjur.configuration.cert_file).strip

