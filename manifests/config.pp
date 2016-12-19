class nessus::config inherits nessus {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $security_center {
    if $activation_code {
      fail('security_center and activation_code are mutually exclusive.')
    }

    if $::nessus_cli {
      $activate_command = 'nessuscli fetch --security-center'
    } else {
      $activate_command = 'nessus-fetch --security-center'
    }

    exec { 'Activate Nessus':
      path    => [ '/bin', '/opt/nessus/bin', '/opt/nessus/sbin' ],
      command => "${activate_command} && touch /opt/nessus/var/nessus/security_center_activated",
      creates => '/opt/nessus/var/nessus/security_center_activated',
      notify  => Exec['Wait 60 seconds for Nessus activation'],
    }
  } else {
    if $nessus::activation_code {
      if $::nessus_activation_code != $nessus::activation_code {
        # This nessus is not yet activated or is using a different activation code, let's add/update it!
        if $::nessus_cli {
          $activate_command = "nessuscli fetch --register ${nessus::activation_code}"
        } else {
          $activate_command = "nessus-fetch --register ${nessus::activation_code}"
        }

        exec { 'Activate Nessus':
          path    => [ '/opt/nessus/bin', '/opt/nessus/sbin' ],
          command => $activate_command,
          notify  => Exec['Wait 60 seconds for Nessus activation'],
        }
      }
    }
  }

  # Wait, then restart nessusd after activation
  exec { 'Wait 60 seconds for Nessus activation':
    path        => [ '/bin' ],
    command     => 'sleep 60',
    refreshonly => true,
    notify      => Service[$service_name],
  }

  #TODO:
  # More config items will be added in the next version of this module
}
