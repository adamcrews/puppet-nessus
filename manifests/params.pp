class nessus::params {

  $package_name   = 'Nessus'
  $package_ensure = 'installed'
  $service_name   = 'nessusd'
  $service_ensure = 'running'
  $service_manage = true

}
