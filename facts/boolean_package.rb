require 'puppet'
require 'puppet/type/package'
Facter.add(:vim) do
  setcode do
    results = Puppet::Type::Package.instances.select { |p| p.name == 'vim-common'}
    results.length > 0
  end
end
