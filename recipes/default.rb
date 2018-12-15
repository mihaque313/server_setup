#
# Cookbook:: server_setup
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'server_setup::java'
include_recipe 'server_setup::tomcat'
