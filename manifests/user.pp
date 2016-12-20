# Manage Nessus user
define nessus::user (
  $ensure    = 'present',
  $password  = undef,
  $user_base = '/opt/nessus/var/nessus/users',
  $admin     = false,
) {

  include '::nessus'

  if $nessus::agent {
    fail('You cannot manage nessus users on $agent nodes')
  }

  validate_re(
    $ensure,
    ['^present', '^absent'],
    "nessus::user \$ensure must be present or absent, not ${ensure}")
  validate_bool($admin)
  validate_string($password)
  validate_string($user_base)

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Package[$nessus::virtual_package_name],
  }

  # Make sure that there is a toplevel user dir.
  if ! defined(File[$user_base]) {
    file { $user_base:
      ensure  => directory,
    }
  }

  if $ensure == 'present' {
    # create our directory structure for a user
    file { [
        "${user_base}/${title}",
        "${user_base}/${title}/auth",
        "${user_base}/${title}/reports" ]:
      ensure => directory,
    }

    # Set the password.  It's recorded in clear, but the file is only readable by root.
    file { "${user_base}/${title}/auth/password":
      ensure  => file,
      content => "${password}\n",
      notify  => Service[$nessus::virtual_service_name],
    }

    # For the clear txt password to work, we need to ensure there is no hash file.
    file { "${user_base}/${title}/auth/hash":
      ensure => absent,
      notify => Service[$nessus::virtual_service_name],
    }

    $_admin_file_ensure = $admin ? {
      true    => file,
      default => absent,
    }

    # if we are an admin, just touch the admin file
    file { "${user_base}/${title}/auth/admin":
      ensure => $_admin_file_ensure,
      notify => Service[$nessus::virtual_service_name],
    }

    file { "${user_base}/${title}/auth/rules":
      ensure => file,
    }

  } elsif $ensure == 'absent' {
    file { "${user_base}/${title}":
      ensure  => absent,
      backup  => false,
      recurse => true,
      notify  => Service[$nessus::virtual_service_name],
    }
  }
}
