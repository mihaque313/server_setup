
puts "Installing java 8:"
apt_package 'openjdk-8-jdk' do
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
