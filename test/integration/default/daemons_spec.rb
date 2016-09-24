control 'creates journald drop-ins' do
  describe file('/etc/systemd/journald.conf.d/my-overrides.conf') do
    its(:content) do
      should eq <<EOT
[Journal]
Compress = yes
SystemKeepFree = 1G
ForwardToSyslog = yes
EOT
    end
  end
end

control 'creates logind drop-ins' do
  describe file('/etc/systemd/logind.conf.d/my-overrides.conf') do
    its(:content) do
      should eq <<EOT
[Login]
KillUserProcesses = yes
KillOnlyUsers = vagrant
EOT
    end
  end
end

control 'creates resolved drop-ins' do
  describe file('/etc/systemd/resolved.conf.d/my-overrides.conf') do
    its(:content) do
      should eq <<EOT
[Resolve]
DNS = 208.67.222.222 208.67.220.220
FallbackDNS = 8.8.8.8 8.8.4.4
EOT
    end
  end
end

control 'creates timesyncd drop-ins' do
  describe file('/etc/systemd/timesyncd.conf.d/my-overrides.conf') do
    its(:content) do
      should eq <<EOT
[Time]
NTP = 0.fedora.pool.ntp.org 1.fedora.pool.ntp.org 2.fedora.pool.ntp.org 3.fedora.pool.ntp.org
FallbackNTP = 0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org
EOT
    end
  end
end
