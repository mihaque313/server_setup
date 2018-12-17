# apt_update 'update'

apt_update 'update'

apt_package 'default-jdk' do
  action :install
  options '-y'
  notifies :run, 'ruby_block[Set JAVA_HOME]', :immediately
end

ruby_block 'Set JAVA_HOME' do
    block do
      file = Chef::Util::FileEdit.new('/etc/environment')
      file.insert_line_if_no_match(/^JAVA_HOME=/, "JAVA_HOME=#{node['java']['java_home']}")
      file.search_file_replace_line(/^JAVA_HOME=/, "JAVA_HOME=#{node['java']['java_home']}")
      file.write_file
    end
    action :nothing
  end
