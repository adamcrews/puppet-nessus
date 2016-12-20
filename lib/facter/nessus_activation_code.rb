Facter.add('nessus_activation_code') do
  confine :kernel => 'Linux'
  setcode do
    if File.exist? '/opt/nessus/bin/nessus-fetch'
      output = `/opt/nessus/bin/nessus-fetch --code-in-use 2>/dev/null`
      output.chomp.split(': ')[-1]
    elsif File.exists? '/opt/nessus/bin/nessuscli'
      output =  `/opt/nessus/bin/nessuscli fix --list --secure 2>/dev/null | grep '^registration_code:'`
      output.chomp.split(': ')[-1]
    elsif File.exists? '/opt/nessus/sbin/nessuscli'
      output =  `/opt/nessus/sbin/nessuscli fix --list --secure 2>/dev/null | grep '^registration_code:'`
      output.chomp.split(': ')[-1]
    end
  end
end
