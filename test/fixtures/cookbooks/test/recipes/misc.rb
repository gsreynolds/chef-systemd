
systemd_system 'my-overrides' do
  manager do
    default_environment({ 'ENVIRONMENT' => 'production' })
    default_timeout_start_sec 30
  end
end

systemd_user 'my-overrides' do
  manager do
    default_environment({ 'ENVIRONMENT' => 'production' })
    default_timeout_start_sec 120
  end
end

systemd_binfmt 'DOSWin' do
  magic 'MZ'
  interpreter '/usr/bin/wine'
end

systemd_modules 'die-beep-die' do
  blacklist true
  modules %w( pcspkr )
  action [:create, :unload]
end

# Test creating, loading
systemd_modules 'zlib' do
  modules %w( zlib )
  action [:create, :load]
end

systemd_sysctl 'vm.swappiness' do
  value 10
  action [:create, :apply]
end

systemd_sysuser '_testuser' do
  id 65_530
  gecos 'my test user'
  home '/var/lib/test'
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=823322
  only_if { platform?('fedora') }
end

systemd_tmpfile 'my-app' do
  path '/tmp/my-app'
  age '10d'
  type 'f'
end

systemd_machine_image 'Fedora-24' do
  type 'raw'
  source 'https://dl.fedoraproject.org/pub/fedora/linux/releases/24/CloudImages/x86_64/images/Fedora-Cloud-Base-24-1.2.x86_64.raw.xz'
  verify 'no'
  read_only true
  format 'gzip'
  path '/var/tmp/Fedora-24.raw.gz'
  to 'cloned'
  action [:pull, :set_properties, :export, :clone]
end

systemd_machine_image 'Fedora-24-b' do
  type 'raw'
  verify 'no'
  format 'gzip'
  path '/var/tmp/Fedora-24.raw.gz'
  action [:import]
end

systemd_nspawn 'Fedora-24' do
  exec do
    boot true
  end
  files do
    bind '/tmp:/tmp'
  end
  network do
    private false
    virtual_ethernet false
  end
end

