Facter.add(:centrify) do
  setcode do
    instance = Puppet::Type.type('package').instances.select { |pkg| pkg.name == 'centrify-ssh' }.first
    if instance
      ensure_property = instance.property(:ensure)
      instance.retrieve[ensure_property]
    end
  end
end
