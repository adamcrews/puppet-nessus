# == Class: nessus
#
# Install and manage the Nessus vulnerability scanner.
#
# === Parameters
#
# [*activation_code*]
#   The nessus code used to activate home or professional feeds.
#
# [*package_name*]
#   The name of the package to install
#
# [*package_ensure*]
#   Ensure the package is installed, latest, or absent.
#
# [*service_name*]
#   The name of the nessus service.
#
# [*service_ensure*]
#   State if the service should be running or stopped.
#
# [*service_manage*]
#   State if the service should be managed or ignored.
#
# === Variables
#
# None used other than parameters.
#
# === Examples
#
#  class { nessus:
#   activation_code => '9999-XXXX-9999-XXXX'
#  }
#
#  # Create a user.
#  nessus::user { 'admin':
#   password => '1adam12_1adam12',
#   admin    => true,
#  }
#
# === Authors
#
# Adam Crews <adam.crews@gmail.com>
#
# === Copyright
#
# Copyright 2014 Adam Crews, unless otherwise noted.
#
class nessus (

  $package_ensure           = $nessus::params::package_ensure,
  $package_version          = $nessus::params::package_version,
  $package_name             = $nessus::params::package_name,
  $package_name_agent       = $nessus::params::package_name_agent,

  $local_package            = $nessus::params::local_package,
  $local_package_folder     = $nessus::params::local_package_folder,
  $local_package_provider   = $nessus::params::local_package_provider,
  $local_package_name       = $nessus::params::local_package_name,
  $local_package_name_agent = $nessus::params::local_package_name_agent,

  $service_manage           = $nessus::params::service_manage,
  $service_ensure           = $nessus::params::service_ensure,
  $service_enable           = $nessus::params::service_enable,
  $service_name             = $nessus::params::service_name,
  $service_name_agent       = $nessus::params::service_name_agent,

  # Register Nessus online
  $activation_code          = undef,

  # Register Nessus with Security center
  $security_center          = $nessus::params::security_center,

  # Register Nessus Agent with Nessus Manager
  $agent                    = $nessus::params::agent,
  $agent_manager_key        = undef,
  $agent_manager_host       = undef,
  $agent_manager_port       = $nessus::params::agent_manager_port,
  $agent_name               = undef,
  $agent_groups             = [],
  $agent_proxy_host         = undef,
  $agent_proxy_port         = undef,
  $agent_proxy_username     = undef,
  $agent_proxy_password     = undef,
  $agent_proxy_agent        = undef,

  # Create Nessus users
  $users                    = {},

) inherits nessus::params {

  if $agent {
    $virtual_package_name = $package_name_agent
    $virtual_service_name = $service_name_agent
  } else {
    $virtual_package_name = $package_name
    $virtual_service_name = $service_name
  }

  if $nessus::local_package {
    $virtual_package_ensure   = $nessus::package_version
    $virtual_package_provider = $nessus::local_package_provider
    if $nessus::agent {
      $virtual_package_source = "${nessus::local_package_folder}/${nessus::local_package_name_agent}"
    } else {
      $virtual_package_source = "${nessus::local_package_folder}/${nessus::local_package_name}"
    }
  } else {
    $virtual_package_ensure   = $nessus::package_ensure
    $virtual_package_provider = undef
    $virtual_package_source   = undef
  }

  if ($nessus::security_center and $nessus::activation_code) or
    ($nessus::activation_code and $nessus::agent) or
    ($nessus::agent and $nessus::security_center) {
    fail('$security_center, $agent and $activation_code are mutually exclusive.')
  }

  validate_hash($users)
  create_resources('::nessus::user', $users)

  anchor { 'nessus::begin': } ->
    class { 'nessus::install': } ->
    class { 'nessus::service': } ->
    class { 'nessus::config': } ->
  anchor { 'nessus::end': }

}
