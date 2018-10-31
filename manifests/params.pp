# This class takes a small number of arguments (can be set through Hiera) and
# generates sane default values installation media names and locations.
# This is a parameters class, and contributes no resources to the graph.
# Rather, it only sets values for parameters to be consumed by child classes.
class nessus::params {

  $port                 = '8834'
  $local_package        = false
  $local_package_folder = '/var/tmp/nessus'
  $package_ensure       = 'installed'
  $package_version      = '7.1.1'
  $package_prefix       = 'Nessus'
  $service_ensure       = 'running'
  $service_enable       = true
  $service_manage       = true
  $security_center      = false
  $agent                = false
  $agent_manager_port   = $port
  $agent_package_prefix = 'NessusAgent'

  case $::osfamily {
    'Debian': {

      $package_name              = 'nessus'
      $service_name              = 'nessusd'
      $package_name_agent        = 'nessusagent'
      $service_name_agent        = 'nessusagent'
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

      $package_name              = 'nessus'
      $service_name              = 'nessusd'
      $package_name_agent        = 'nessusagent'
      $service_name_agent        = 'nessusagent'
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

  $local_package_name       = "${package_prefix}-${package_version}-${package_archive_suffix}_${::architecture}.${package_archive_extension}"
  $local_package_name_agent = "${agent_package_prefix}-${package_version}-${package_archive_suffix}_${::architecture}.${package_archive_extension}"

}
