def self.resource_type
  :sleep
end

include SystemdCookbook::ResourceFactory::Daemon
