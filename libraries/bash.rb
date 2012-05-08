module Bootstrap
  module Bash
    def configure_bash
      if new_resource.bash?
        bash_action = :create
      else
        bash_action = :delete
      end

      cookbook_file "#{new_resource.home_path}/.bashrc" do
        cookbook "bootstrap"
        source "bashrc"
        owner new_resource.username
        group new_resource.username
        mode "0644"
        backup false
        action bash_action
      end

      cookbook_file "#{new_resource.home_path}/.bash_aliases" do
        cookbook "bootstrap"
        source "bash_aliases"
        owner new_resource.username
        group new_resource.username
        mode "0644"
        backup false
        action bash_action
      end

      cookbook_file "#{new_resource.home_path}/.profile" do
        cookbook "bootstrap"
        source "profile"
        owner new_resource.username
        group new_resource.username
        mode "0644"
        backup false
        action bash_action
      end
    end

    def configure_bash_profile
      if new_resource.profile.any?
        default_profile_action = :create
      else
        default_profile_action = :delete
      end
      bootstrap_profile new_resource.username do
        user    new_resource
        params  new_resource.profile
        action  default_profile_action
      end
    end
  end
end
