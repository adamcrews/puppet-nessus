# Configure Nessus
class nessus::config inherits nessus {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $::nessus_version and versioncmp($::nessus_version, '6.0.0') < 0 or
    $nessus::package_version and versioncmp($nessus::package_version, '6.0.0') < 0 {
    $_nessus_fetch_command = 'nessus-fetch'
    $_nessus_agent_available = false
  } else {
    $_nessus_fetch_command = 'nessuscli fetch'
    $_nessus_agent_available = true
  }

  validate_bool($nessus::security_center)
  if $nessus::security_center {
  ##########################
  # Register Nessus with Security center
  ##########################
    exec { 'Register Nessus with SecurityCenter,':
      path    => [ '/bin', '/opt/nessus/bin', '/opt/nessus/sbin' ],
      command => "${$_nessus_fetch_command} --security-center \
                  && touch /opt/nessus/var/nessus/security_center_activated",
      creates => '/opt/nessus/var/nessus/security_center_activated',
    }
  } elsif $nessus::agent {
  ##########################
  # Register Nessus Agent with Nessus Manager
  ##########################
    if !$_nessus_agent_available {
      fail('Nessus agent can only be used with Nessus 6.0+')
    }

    validate_re(
      $nessus::agent_manager_key,
      '^[a-f0-9]{64}$',
      '$agent_manager_key must be a valid manager key')
    validate_string($nessus::agent_manager_host)
    validate_integer($nessus::agent_manager_port)

    if ! empty($nessus::agent_name) {
      $link_command_name = "--name=${nessus::agent_name}"
    }

    if ! empty($nessus::agent_groups) {
      validate_array($nessus::agent_groups)
      $_agent_groups = join($nessus::agent_groups, ',')
      $link_command_groups = "--groups=${_agent_groups}"
    }

    if ! empty($nessus::agent_proxy_host) {
      validate_string($nessus::agent_proxy_host)
      $link_command_proxy_host = "--proxy-host=${nessus::agent_proxy_host}"
    }

    if $nessus::agent_proxy_port {
      validate_integer($nessus::agent_proxy_port)
      $link_command_proxy_port = "--proxy-port=${nessus::agent_proxy_port}"
    }

    if ! empty($nessus::agent_proxy_username) {
      validate_string($nessus::agent_proxy_username)
      $link_command_proxy_username = "--proxy-username=${nessus::agent_proxy_username}"
    }

    if ! empty($nessus::agent_proxy_password) {
      validate_string($nessus::agent_proxy_password)
      $link_command_proxy_password = "--proxy-password=${nessus::agent_proxy_password}"
    }

    if ! empty($nessus::agent_proxy_agent) {
      validate_string($nessus::agent_proxy_agent)
      $link_command_proxy_agent = "--proxy-agent=${nessus::agent_proxy_agent}"
    }

    if ! $::nessus_manager_linked_once
      or $::nessus_manager_ip != $nessus::agent_manager_host
      or $::nessus_manager_port != $nessus::agent_manager_port {

      $link_command = [
        'nessuscli agent link',
        "--key=${nessus::agent_manager_key}",
        "--host=${nessus::agent_manager_host}",
        "--port=${nessus::agent_manager_port}",
      ]

      $_link_command = join($link_command, ' ')

      exec { 'Link NessusAgent with NessusManager':
        path    => [ '/opt/nessus_agent/bin', '/opt/nessus_agent/sbin' ],
        command => "${_link_command} \
                    ${link_command_name} \
                    ${link_command_groups} \
                    ${link_command_proxy_host} \
                    ${link_command_proxy_port} \
                    ${link_command_proxy_username} \
                    ${link_command_proxy_password} \
                    ${link_command_proxy_agent}",
      }
    }
  } else {
  ##########################
  # Register Nessus online (default)
  ##########################
    if $nessus::activation_code {
      validate_re(
        $nessus::activation_code,
        '^[A-Z0-9]{4}\-[A-Z0-9]{4}\-[A-Z0-9]{4}\-[A-Z0-9]{4}\-[A-Z0-9]{4}$',
        '$activation_code must be a valid activation code')
      if $::nessus_activation_code != $nessus::activation_code {
        # This nessus is not yet activated or is using a different activation code, let's add/update it!
        exec { 'Register Nessus online':
          path    => [ '/opt/nessus/bin', '/opt/nessus/sbin' ],
          command => "${$_nessus_fetch_command} --register ${nessus::activation_code}",
          # notify  => Exec['Wait 60 seconds for Nessus activation'],
        }
      } else {
        notice('Nessus has not been activated. Use $activation_code to provide a valid activation key')
      }
    }
  }

  #TODO:
  # More config items will be added in the next version of this module
}
