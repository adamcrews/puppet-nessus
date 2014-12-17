Facter.add('nessus_cli') do
  confine :kernel => 'Linux'
  setcode do
    result = false
    if File.exists? '/opt/nessus/bin/nessuscli'
      result = true
    elsif File.exists? '/opt/nessus/sbin/nessuscli'
      result = true
    end
    result
  end
end
