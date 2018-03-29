# This fact is used on windows machines in order to query
# wmi for the logon as account assigned to the puppet service.  Puppet can be changed to list any other service using
# the same name as would be found in WMI (or more simply, how puppet recognizes service names)
Facter.add('service_account') do
  confine kernel: 'windows'
  setcode do
    sysroot = ENV['SystemRoot']
    programdata = ENV['ProgramData']
    powershell = "#{sysroot}\\system32\\WindowsPowerShell\\v1.0\\powershell.exe"
    command = '"import-module Microsoft.Powershell.Utility| Get-WmiObject win32_service -Filter {name = \"puppet\"} | Select-Object -Expandproperty Startname"'
    Facter::Util::Resolution.exec("#{powershell} -ExecutionPolicy Unrestricted -command #{command}")
  end
end
