# GETTING STARTED
# Originally written by Nate McCurdy
# 1. Install the Puppet agent from http://downloads.puppetlabs.com/windows/puppet-agent-1.3.6-x64.msi
# 2. puppet module install chocolatey-chocolatey
# 3. puppet module install cyberious-apm
# 4. puppet apply windows_dev_node.pp

include chocolatey

$choco_packages = [
  'git',
  'atom',
  'psget',
  'poshgit',
  'conemu',
  'ruby',
]

package { $choco_packages:
  ensure   => present,
  provider => 'chocolatey',
}

$gem_packages = [
  'puppet-lint',
  'r10k',
  'hiera-eyaml',
]

# Due to the bug at the link below, the install_options need to be set
# so that Puppet doesn't try to install the gem into its own Ruby stack.
# This also makes this resource *not* idempotent, but as this is mostly just a
# one-time provisioning script, that's not a deal-breaker.
# https://tickets.puppetlabs.com/browse/PUP-6134
$gem_packages.each | $gem_pkg | {
  package { "gem_${gem_pkg}":
    ensure          => present,
    name            => $gem_pkg,
    provider        => 'gem',
    install_options => {
      '--install-dir' => 'C:\tools\ruby23\lib\ruby\gems\2.3.0',
      '--bindir'      => 'c:\tools\ruby23\bin'},
    require         => Package['ruby'],
  }
}

$apm_packages = [
  'language-puppet',
  'linter',
  'linter-puppet-lint',
  'linter-erb',
  'linter-puppet-parser',
  'aligner',
  'aligner-puppet',
  'aligner-ruby',
  'git-plus',
  'minimap',
]

$apm_packages.each | $apm_pkg | {
  package { "apm_${apm_pkg}":
    ensure   => present,
    name     => $apm_pkg,
    provider => 'apm',
    require  => Package['atom'],
  }
}

exec { 'git alias: unstage':
  command => 'git config --global alias.unstage "reset HEAD --"',
  path    => $::path,
}

exec { 'git alias: co':
  command => 'git config --global alias.co "checkout"',
  path    => $::path,
}

exec { 'git alias: hist':
  command => "git config --global alias.hist \"log --pretty=format:'%C(yellow)[%ad]%C(reset) %C(green)[%h]%C(reset) | %C(red)%s %C(bold red){{%an}}%C(reset) %C(blue)%d%C(reset)' --graph --date=short\"",
  path    => $::path,
}
