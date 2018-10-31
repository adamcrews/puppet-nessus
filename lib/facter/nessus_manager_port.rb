Facter.add('nessus_manager_port') do
  confine :kernel => 'Linux'
  nessuscli_paths = ['/opt/nessus_agent/bin/nessuscli','/opt/nessus_agent/sbin/nessuscli']
  setcode do
    if !Dir.glob(nessuscli_paths).empty?
      nessuscli = Dir.glob(nessuscli_paths).first
      output = Facter::Core::Execution.exec("#{nessuscli} fix --list --secure 2>/dev/null")
      unless output.nil?
        output.split("\n").
          select { |x| x =~ %r{^ms_server_port:} }.first.chomp.split(': ').last
      end
    end
  end
end
