Facter.add('nessus_activation_code') do
  confine :kernel => 'Linux'
  setcode do
    if File.exists? '/opt/nessus/bin/nessuscli'
      output = `/opt/nessus/bin/nessuscli fetch --code-in-use 2>/dev/null | grep 'Activation Code:'`
      output.split(': ')[-1].delete("\n")
    elsif File.exists? '/opt/nessus/sbin/nessuscli'
      output = `/opt/nessus/sbin/nessuscli fetch --code-in-use 2>/dev/null | grep 'Activation Code:'`
      output.split(': ')[-1].delete("\n")
    end
  end
end
