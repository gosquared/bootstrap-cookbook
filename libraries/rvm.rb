module Bootstrap
  module RVM
    def configure_rvm
      if new_resource.rvm?
        rvm_action = :create
      else
        rvm_action = :delete
      end

      file "#{new_resource.home_path}/.gemrc" do
        owner new_resource.username
        group new_resource.username
        content "gem: --no-user-install --no-ri --no-rdoc"
        mode "0644"
        action rvm_action
      end

      template "#{new_resource.home_path}/.rvmrc" do
        cookbook "rvm"
        source "rvmrc.erb"
        owner new_resource.username
        group new_resource.username
        mode "0644"
        backup false
        action rvm_action
      end

      bootstrap_profile new_resource.username do
        user new_resource
        filename "rvm"
        params([
          "[ -f #{node.rvm_script} ] && . '#{node.rvm_script}'",
          "export RAILS_ENV=production",
          "export RACK_ENV=production",
          "export APP_ENV=production"
        ])
        action rvm_action
      end
    end
  end
end
