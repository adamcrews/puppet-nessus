Facter.add('nessus_manager_port') do
  confine :kernel => 'Linux'
  setcode do
    if File.exists? '/opt/nessus_agent/bin/nessuscli'
      output =  `/opt/nessus_agent/bin/nessuscli fix --secure --list 2>/dev/null | grep '^ms_server_port:'`
      output.chomp.split(': ')[-1]
    elsif File.exists? '/opt/nessus_agent/sbin/nessuscli'
      output =  `/opt/nessus_agent/sbin/nessuscli fix --secure --list 2>/dev/null | grep '^ms_server_port:'`
      output.chomp.split(': ')[-1]
    end
  end
end
