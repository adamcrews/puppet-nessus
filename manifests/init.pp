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
  $activation_code  = undef,
  $package_name     = $nessus::params::package_name,
  $package_ensure   = $nessus::params::package_ensure,
  $service_name     = $nessus::params::service_name,
  $service_ensure   = $nessus::params::service_ensure,
  $service_enable   = $nessus::params::service_enable,
  $service_manage   = $nessus::params::service_manage,
  $security_center  = $nessus::params::security_center,
) inherits nessus::params {

  validate_string($package_name)
  validate_string($package_ensure)
  validate_string($service_name)
  validate_re($service_ensure, ['^running', '^stopped'], '$service_ensure must be running or stopped')
  validate_bool($service_manage)
  validate_bool($security_center)

  if $activation_code {
    validate_string($activation_code)
  }

  anchor { 'nessus::begin': } ->
    class { 'nessus::install': } ->
    class { 'nessus::config': } ->
    class { 'nessus::service': } ->
  anchor { 'nessus::end': }

}
