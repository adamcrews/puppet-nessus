Facter.add('nessus_cli') do
  confine :kernel => 'Linux'
  nessuscli_paths = [
    '/opt/nessus/bin/nessuscli',
    '/opt/nessus/sbin/nessuscli',
    '/opt/nessus_agent/bin/nessuscli',
    '/opt/nessus_agent/sbin/nessuscli'
  ]
  setcode do
    if !Dir.glob(nessuscli_paths).empty?
      true
    else
      false
    end
  end
end
