# Manage Nessus service
class nessus::service inherits nessus {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $nessus::service_manage == true {
    service { 'nessus':
      ensure     => $nessus::service_ensure,
      enable     => $nessus::service_enable,
      name       => $nessus::service_name,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
