Facter.add('nessus_version') do
  confine :kernel => 'Linux'
  setcode do
    if File.exists? '/opt/nessus/sbin/nessusd'
      Facter::Core::Execution.exec('/opt/nessus/sbin/nessusd --version | grep --extended-regexp --only-matching "[0-9]+\.[0-9]+\.[0-9]+"').chomp
    elsif File.exists? '/opt/nessus_agent/sbin/nessusd'
      Facter::Core::Execution.exec('/opt/nessus_agent/sbin/nessusd --version | grep --extended-regexp --only-matching "[0-9]+\.[0-9]+\.[0-9]+"').chomp
    end
  end
end
