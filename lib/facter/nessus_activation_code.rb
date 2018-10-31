Facter.add('nessus_activation_code') do
  confine :kernel => 'Linux'
  nessuscli_paths = ['/opt/nessus/bin/nessuscli','/opt/nessus/sbin/nessuscli']
  setcode do
    if File.exist? '/opt/nessus/bin/nessus-fetch'
      output = Facter::Core::Execution.exec('/opt/nessus/bin/nessus-fetch --code-in-use 2>/dev/null')
      unless output.nil?
        output.split(': ').last.chomp
      end
    elsif !Dir.glob(nessuscli_paths).empty?
      nessuscli = Dir.glob(nessuscli_paths).first
      output = Facter::Core::Execution.exec("#{nessuscli} fix --list --secure 2>/dev/null")
      unless output.nil?
        output.split("\n").
          select { |x| x =~ %r{^registration_code:} }.first.chomp.split(': ').last
      end
    end
  end
end
