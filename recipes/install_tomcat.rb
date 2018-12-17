tomcat_url=node['tomcat_v9']['tomcat_url']
tomcat_version=node['tomcat_v9']['tomcat_version']
tomcat_install_dir=node['tomcat_v9']['tomcat_install_dir']
tomcat_user=node['tomcat_v9']['tomcat_user']
java_home=node['java']['java_home']

apt_update 'update'

directory tomcat_install_dir do
  mode '0755'
  recursive true
  action :create
end

group tomcat_user

user tomcat_user do
  group tomcat_user
  system true
  home tomcat_install_dir
  shell "/bin/false"
end

tar_extract "#{tomcat_url}v#{tomcat_version}/bin/apache-tomcat-#{tomcat_version}.tar.gz" do
  target_dir tomcat_install_dir
  tar_flags [ '-P', '--strip-components 1' ]
  not_if { ::File.exist?("#{tomcat_install_dir}/conf") }
  notifies :run, 'script[change_permissions]', :immediately
end

script 'change_permissions' do
  interpreter 'bash'
  cwd tomcat_install_dir
  code <<-EOH
          chgrp -R #{tomcat_user} #{tomcat_install_dir}
          chmod -R g+r conf
          chmod g+x conf
          chown -R #{tomcat_user} webapps/ work/ temp/ logs/
          EOH
  action :nothing
end

template '/etc/systemd/system/tomcat.service' do
  source 'default/tomcat.service.erb'
  variables(
     :JAVA_HOME => java_home,
     :tomcat_install_dir => tomcat_install_dir,
     :tomcat_user => tomcat_user
   )
  notifies :run, 'execute[daemon-reload]', :immediately
end

execute 'daemon-reload' do
  command "systemctl daemon-reload"
  action :nothing
end

service 'tomcat' do
  action [ :enable, :start ]
end
