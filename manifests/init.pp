# == Class: nessus
#
# Install and manage the Nessus vulnerability scanner.
#
# === Parameters
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
# === Authors
#
# Adam Crews <adam.crews@gmail.com>
#
# === Copyright
#
# Copyright 2014 Adam Crews, unless otherwise noted.
#
class nessus (
  $activation_code,
  $package_name   = $nessus::params::package_name,
  $package_ensure = $nessus::params::package_ensure,
  $service_name   = $nessus::params::service_name,
  $service_ensure = $nessus::params::service_ensure,
  $service_manage = $nessus::params::service_manage,
) inherits nessus::params {

  validate_string($activation_code)
  validate_string($package_name)
  validate_string($package_ensure)
  validate_string($service_name)
  validate_re($service_ensure, ['^running', '^stopped'], '$service_ensure must be running or stopped')
  validate_bool($service_manage)

  anchor { 'nessus::begin': } ->
    class { 'nessus::install': } ->
    class { 'nessus::activate': } ->
    class { 'nessus::config': } ->
    class { 'nessus::service': } ->
  anchor { 'nessus::end': }

}
