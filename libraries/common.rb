module Bootstrap
  module Common
    def set_permissions
      directory new_resource.home_path do
        owner new_resource.home_owner
        group new_resource.home_group
        mode  new_resource.home_permission
      end

      bootstrap_user_groups new_resource.username do
        groups new_resource.groups
        allows new_resource.allows
      end
    end

    def configure_ssh
      ssh_authorized_keys new_resource.username do
        ssh_keys  new_resource.ssh_keys
        user_home new_resource.home_path
      end

      cookbook_file "#{new_resource.home_path}/.ssh/config" do
        cookbook "bootstrap"
        source "ssh_config"
        owner new_resource.username
        group new_resource.username
        mode "0644"
        backup false
        action :create_if_missing
      end
    end
  end
end
