# Install Nessus
class nessus::install inherits nessus {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $nessus::use_local_package_archive == true {
    $package_provider = $nessus::local_package_provider
    $package_source   = "${nessus::package_archive_location}/${nessus::package_archive_name}"
  }

  package { $nessus::package_name:
    ensure   => $nessus::package_ensure,
    source   => $package_source,
    provider => $package_provider,
  }

}
