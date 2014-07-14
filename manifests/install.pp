class nessus::install inherits nessus {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { 'nessus':
    ensure => $package_ensure,
    name   => $package_name,
  }

}
