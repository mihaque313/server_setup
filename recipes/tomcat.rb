tomcat_url=node['tomcat_v9']['tomcat_url']
tomcat_version=node['tomcat_v9']['tomcat_version']
tomcat_install_dir=node['tomcat_v9']['tomcat_install_dir']
tomcat_user=node['tomcat_v9']['tomcat_user']
tomcat_auto_start=node['tomcat_v9']['tomcat_auto_start']

puts 'Starting the installation of apache tomcat server.'

apt_update 'update'

group 'tomcat'

user "tomcat" do
  group "tomcat"
  system true
  shell "/bin/bash"
end

directory tomcat_install_dir do
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  recursive true
  action :create
end

tar_extract "#{tomcat_url}v#{tomcat_version}/bin/apache-tomcat-#{tomcat_version}.tar.gz" do
  target_dir tomcat_install_dir
  creates "#{tomcat_install_dir}/apache-tomcat-#{tomcat_version}"
  tar_flags [ '-P', '--strip-components 1' ]
end

script 'change required permissions' do
  interpreter 'bash'
  user 'root'
  cwd tomcat_install_dir
  code <<-EOH
          chgrp -R tomcat bin
          chmod g+rwx bin
          chmod g+r bin/*
          chmod g+x conf
          chmod -R g+r conf
          chown -R tomcat webapps/ work/ temp/ logs/
          EOH
end

template '/etc/systemd/system/tomcat.service' do
  source 'default/tomcat.service.erb'
end

execute 'daemon-reload' do
  command "systemctl daemon-reload"
  action :run
end

service 'tomcat' do
  action [ :enable, :start ]
end
