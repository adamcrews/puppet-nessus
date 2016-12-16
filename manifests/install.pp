# Install Nessus
class nessus::install inherits nessus {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { 'nessus':
    ensure => $nessus::package_ensure,
    name   => $nessus::package_name,
  }

}
