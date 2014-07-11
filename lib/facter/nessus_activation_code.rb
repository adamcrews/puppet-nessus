Facter.add('nessus_activation_code') do
  confine :kernel => 'Linux'
  setcode do
    if File.exist? '/opt/nessus/bin/nessus-fetch'
      output = `/opt/nessus/bin/nessus-fetch --code-in-use 2>/dev/null` 
      output.split(' : ')[-1]
    end
  end
end
