# Manage Nessus service
class nessus::service inherits nessus {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  validate_bool($nessus::service_manage)
  if $nessus::service_manage {
    validate_string($nessus::virtual_service_name)
    validate_re(
      $nessus::service_ensure,
      ['^running', '^stopped'],
      '$service_ensure must be running or stopped')
    validate_bool($nessus::service_enable)

    service { $nessus::virtual_service_name:
      ensure     => $nessus::service_ensure,
      enable     => $nessus::service_enable,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
