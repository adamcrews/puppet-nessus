# Type to manage Nessus users
#
# === Parameters
#
# @param password The user's password
# @param ensure Should the user be present or not
# @param user_base Where are the user stored
# @param admin Is the user an admin user
#
define nessus::user (
  String[1]        $password,
  Nessus::Ensure   $ensure    = present,
  Stdlib::Unixpath $user_base = '/opt/nessus/var/nessus/users',
  Boolean          $admin     = false,
) {
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
    file { [ "${user_base}/${title}", "${user_base}/${title}/auth", "${user_base}/${title}/reports" ]:
      ensure => directory,
    }

    # Set the password.  It's recorded in clear, but the file is only readable by root.
    file { "${user_base}/${title}/auth/password":
      ensure  => file,
      content => "${password}\n",
      notify  => Service['nessus'],
    }

    # For the clear txt password to work, we need to ensure there is no hash file.
    file { "${user_base}/${title}/auth/hash":
      ensure => absent,
      notify => Service['nessus'],
    }

    # if we are an admin, just touch the admin file
    $file_ensure = $admin ? {
      true    => file,
      default => absent,
    }

    file { "${user_base}/${title}/auth/admin":
      ensure => $file_ensure,
      notify => Service['nessus'],
    }

    file { "${user_base}/${title}/auth/rules":
      ensure => file,
    }

  } elsif $ensure == 'absent' {
    file { "${user_base}/${title}":
      ensure  => absent,
      backup  => false,
      recurse => true,
      notify  => Service['nessus'],
    }
  }
}
