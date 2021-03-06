
default['build-essential']['compile_time'] = true

default['riemann']['server']['version'] = '0.2.6'
default['riemann']['server']['user'] = 'riemann'
default['riemann']['server']['home'] = '/var/lib/riemann'
default['riemann']['server']['config_directory'] = '/etc/riemann'
default['riemann']['server']['bind_ip'] = '0.0.0.0'

default['riemann']['dashboard']['port'] = 4567
default['riemann']['dashboard']['bind_address'] = '0.0.0.0'
default['riemann']['dashboard']['user'] = 'riemann-dash'
default['riemann']['dashboard']['home'] = '/var/lib/riemann-dash'
