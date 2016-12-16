# This class takes a small number of arguments (can be set through Hiera) and
# generates sane default values installation media names and locations.
# This is a parameters class, and contributes no resources to the graph.
# Rather, it only sets values for parameters to be consumed by child classes.
class nessus::params {

  $package_ensure  = 'installed'
  $service_ensure  = 'running'
  $service_enable  = true
  $service_manage  = true
  $security_center = false

  case $::osfamily {
    'Debian': {

      $package_name              = 'Nessus'
      $service_name              = 'nessusd'
      $package_archive_extension = 'deb'
      $local_package_provider    = 'dpkg'

      case $::operatingsystem {
        'Debian': {
          $package_archive_suffix = 'debian6'
        }
        'Ubuntu': {
          $package_archive_suffix = $::operatingsystemmajrelease ? {
            /^(9.10|10.04)$/ => 'ubuntu910',
            default          => 'ubuntu1110',
          }
        }
        default: {
          fail("The ${module_name} module is not supported on an ${::operatingsystem} distribution.")
        }
      }
    }
    'RedHat': {

      $package_name              = 'Nessus'
      $service_name              = 'nessusd'
      $package_archive_extension = 'rpm'
      $local_package_provider    = 'rpm'

      case $::operatingsystem {
        'RedHat', 'CentOS': {
          $package_archive_suffix = "es${::operatingsystemmajrelease}"
        }
        default: {
          fail("The ${module_name} module is not supported on an ${::operatingsystem} distribution.")
        }
      }
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }

  $use_local_package_archive = false
  $package_archive_location  = '/var/tmp/nessus'
  $package_archive_prefix    = 'Nessus'
  $package_archive_version   = '6.9.2'
  $package_archive_name      = "${package_archive_prefix}-${package_archive_version}-${package_archive_suffix}_${::architecture}.${package_archive_extension}"

}
