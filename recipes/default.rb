#
# Cookbook:: node_sample_extended
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

include_recipe 'nodejs'

include_recipe 'apt'


# #packages apt-get
# apt_update
# package 'nginx'

#packages apt-get
apt_update 'update_sources' do
  action :update
end

#npm Installs
nodejs_npm 'pm2'

# package 'npm'
package 'nginx'

#services
service 'nginx' do
  action [:start, :enable]
end

# resource template
template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  variables proxy_port: node['nginx']['proxy_port']
  notifies :restart, 'service[nginx]'
end

# resource link
link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/default' do
  action :delete
  notifies :restart, 'service[nginx]'
end
