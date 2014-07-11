define nessus::user (
  $ensure     = 'present',
  $password   = undef,
  $user_base  = '/opt/nessus/var/nessus/users',
  $admin      = false,
) { 

  validate_re($ensure, ['^present', '^absent'], "nessus::user \$ensure must be present or absent, not ${ensure}")
  validate_bool($admin)
  validate_string($password)
  validate_string($user_base)


  File { 
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Package['nessus'],
  }

  # Make sure that there is a toplevel user dir.
  if ! defined(File[$user_base]) {
    file { $user_base:
      ensure  => directory,
    }
  }

  if $ensure == 'present' {
    # create our directory structure for a user
    file { [ "${user_base}/${title}", "${user_base}/${title}/auth", "${user_base}/${title}/reports", "${user_base}/${title}/files" ]:
      ensure => directory,
    }

    # set the password in the clear. :-(
    file { "${user_base}/${title}/auth/password":
      ensure  => file,
      content => "${password}\n",
    }

    # remove the hash, in favor of the password above
    file { "${user_base}/${title}/auth/hash":
      ensure => absent,
    }

    # if we are an admin, just touch the admin file
    file { "${user_base}/${title}/auth/admin":
      ensure => $admin ? {
        true    => file,
        default => absent,
      }
    }

  } elsif $ensure == 'absent' {
    file { "${user_base}/${title}":
      ensure  => absent,
      backup  => false,
      recurse => true,
    }
  }
}
