apt_update 'update'

apt_package 'postgresql' do
  action :install
  options '-y'
end

apt_package 'postgresql-contrib' do
  action :install
  options '-y'
end

