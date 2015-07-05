require 'chef/resource/lwrp_base'
require_relative 'systemd_install'
require_relative 'systemd_unit'
require_relative 'helpers'

class Chef::Resource
  class SystemdUnit < Chef::Resource::LWRPBase
    self.resource_name = :systemd_unit
    provides :systemd_unit

    actions :create, :delete
    default_action :create

    attribute(
      :unit_type,
      kind_of: Symbol,
      equal_to: Systemd::Helpers.unit_types,
      default: :service,
      required: true
    )

    %w( unit install ).each do |section|
      Systemd.const_get(section.capitalize)::OPTIONS.each do |option|
        attribute option.underscore.to_sym, kind_of: String, default: nil
      end

      define_method(section) do |&b|
        b.call
      end
    end

    # rubocop: disable AbcSize
    def to_hash
      conf = {}
      ['unit', 'install', unit_type.to_s].each do |section|
        # Some units types don't have type-specific config blocks
        next if Systemd::Helpers.stub_units.include? section.to_sym
        conf[section] = []
        Systemd.const_get(section.capitalize)::OPTIONS.each do |option|
          attr = send(option.underscore.to_sym)
          conf[section] << "#{option.camelize}=#{attr}" unless attr.nil?
        end
      end
      conf
    end
    # rubocop: enable AbcSize
  end
end
