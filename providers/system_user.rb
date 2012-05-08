action :create do
  user new_resource.username do
    supports  :manage_home => true
    home      new_resource.home_path
    shell     new_resource.shell
    password  new_resource.hashed_password
  end

  set_permissions
  configure_ssh
  configure_rvm

  configure_bash
  configure_bash_profile
end

action :disable do

end

action :delete do

end

def load_current_resource
  extend Bootstrap::Common
  extend Bootstrap::RVM
  extend Bootstrap::Bash
end
