#
# Cookbook Name:: riemann-server
# Recipe:: server
#
# Copyright (C) 2013 cloudbau GmbH
# Copyright (C) 2014 Criteo
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'java'

user node['riemann']['server']['user'] do
  home node['riemann']['server']['home']
  shell "/bin/bash"
  system true
end

# Installs riemann package:
if platform_family?("debian")
  remote_file "/tmp/riemann_#{node[:riemann][:server][:version]}_all.deb" do
    source "http://aphyr.com/riemann/riemann_#{node[:riemann][:server][:version]}_all.deb"
    mode 0644
    not_if "dpkg -s riemann | grep Version | grep #{node[:riemann][:server][:version]}"
    notifies :install, "dpkg_package[riemann]", :immediately
  end

  dpkg_package "riemann" do
    source "/tmp/riemann_#{node[:riemann][:server][:version]}_all.deb"
    action :nothing
  end
elsif platform?("redhat", "centos", "fedora", "amazon", "scientific")
  include_recipe "yum-epel"
  remote_file "/tmp/riemann-#{node[:riemann][:server][:version]}-1.noarch.rpm" do
    source "http://aphyr.com/riemann/riemann-#{node[:riemann][:server][:version]}-1.noarch.rpm"
    mode 0644
  end
  yum_package "/tmp/riemann-#{node[:riemann][:server][:version]}-1.noarch.rpm"
end

directory "/var/log/riemann/" do
  mode 0755
  owner node['riemann']['server']['user']
  group node['riemann']['server']['user']
  action :create
end

directory "/usr/lib/riemann" do
  mode 0775
  owner 'riemann'
  group 'riemann'
  action :create
end

service "riemann" do
  supports :restart => true
  action [:enable, :start]
end

template "/etc/riemann/riemann.config" do
  source "server/riemann.config.erb"
  owner "root"
  group "root"
  mode 0644

  notifies :restart, resources(:service => 'riemann')
  variables :bind_ip => node[:riemann][:server][:bind_ip]
end


