include ::nessus

nessus::user { 'joebob':
  password => 'joebobpass',
}

nessus::user { 'joebobadmin':
  password => 'joebobadminpass',
  admin    => true,
}
