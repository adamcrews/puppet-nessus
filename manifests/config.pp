class nessus::config inherits nessus {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if ! $::nessus_activation_code {
    # This nessus is not yet activated, let's do it!
    if $activation_code {
      exec { 'Activate Nessus':
        path    => [ '/opt/nessus/bin', '/opt/nessus/sbin' ],
        command => "nessus-fetch --register ${activation_code}"
      }

      # Wait, then restart nessusd after activation
      exec { 'Wait 60 seconds for Nessus activation':
        path        => [ '/bin' ],
        command     => 'sleep 60',
        refreshonly => true,
        subscribe   => Exec['Activate Nessus'],
        notify      => Service[$service_name],
      }
    }
  }

  #TODO:
  # More config items will be added in the next version of this module
}
