
apt_update 'update' do
  options '-y'
end

apt_package 'default-jre' do
  action :install
  options '-y'
end

apt_package 'default-jdk' do
  action :install
  options '-y'
end

directory '/etc/profile.d' do
  mode '0755'
end

template '/etc/profile.d/jdk.sh' do
  source 'default/jdk.sh.erb'
  mode '0755'
end

ruby_block 'Set JAVA_HOME in /etc/environment' do
    block do
      file = Chef::Util::FileEdit.new('/etc/environment')
      file.insert_line_if_no_match(/^JAVA_HOME=/, "JAVA_HOME=#{node['java']['java_home']}")
      file.search_file_replace_line(/^JAVA_HOME=/, "JAVA_HOME=#{node['java']['java_home']}")
      file.write_file
    end
  end

script 'source /etc/environment' do
  interpreter 'bash'
  user 'root'
  code <<-EOH
          source /etc/environment
          EOH
end
