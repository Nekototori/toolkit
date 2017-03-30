###################
# package_boolean #
###################  
#  
# This fact will use the Puppet RAL to query whether a package has been
# installed (using the default package provider). If it is, it will return
# true, otherwise it will return false. 
#
# To specify the name of the package you're looking for, just change the
# "package" variable below from 'bash' to the package name as known by the
# default package provider.
#
require 'puppet'
require 'puppet/type/package'
Facter.add(:vim) do
  setcode do
    package = 'bash'
    results = Puppet::Type::Package.instances.select { |p| p.name == package}
    results.length > 0
  end
end
