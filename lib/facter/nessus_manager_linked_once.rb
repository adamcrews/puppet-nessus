Facter.add('nessus_manager_linked_once') do
  confine :kernel => 'Linux'
  setcode do
    if File.exists? '/opt/nessus_agent/bin/nessuscli'
      output =  `/opt/nessus_agent/bin/nessuscli fix --secure --list 2>/dev/null | grep '^linked_once:'`
      output.chomp.split(': ')[-1]
    elsif File.exists? '/opt/nessus_agent/sbin/nessuscli'
      output =  `/opt/nessus_agent/sbin/nessuscli fix --secure --list 2>/dev/null | grep '^linked_once:'`
      output.chomp.split(': ')[-1]
    end
  end
end