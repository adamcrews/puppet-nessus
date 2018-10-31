# Install Nessus
class nessus::install inherits nessus {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  validate_string($nessus::virtual_package_name)
  validate_string($nessus::virtual_package_ensure)

  validate_bool($nessus::local_package)
  if $nessus::local_package {
    validate_string($nessus::virtual_package_source)
    validate_string($nessus::virtual_package_provider)
  }

  package { $nessus::virtual_package_name:
    ensure   => $nessus::package_ensure,
    source   => $nessus::virtual_package_source,
    provider => $nessus::virtual_package_provider,
  }

}
