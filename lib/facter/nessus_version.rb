Facter.add('nessus_version') do
  confine :kernel => 'Linux'
  nessusd_paths = ['/opt/nessus/sbin/nessusd','/opt/nessus_agent/sbin/nessusd']
  setcode do
    if !Dir.glob(nessusd_paths).empty?
      nessusd = Dir.glob(nessusd_paths).first
      output = Facter::Core::Execution.exec("#{nessusd} --version 2>/dev/null")
      unless output.nil?
        output.split("\n").first.split(' ').
          select { |x| x =~ %r{^(?:(\d+)\.)(?:(\d+)\.)?(\*|\d+)} }.first.chomp
      end
    end
  end
end
