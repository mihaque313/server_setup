#
# Cookbook:: server_setup
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'server_setup::install_java'
include_recipe 'server_setup::install_tomcat'
include_recipe 'server_setup::install_postsql'
