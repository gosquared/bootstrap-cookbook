action :create do
  directory "#{new_resource.user.home_path}/.profile.d" do
    owner new_resource.user.name
    group new_resource.user.name
    mode "0755"
  end

  template "#{new_resource.user.home_path}/.profile.d/#{new_resource.filename}" do
    cookbook "bootstrap"
    source "profile.d.erb"
    variables(
      :params => new_resource.params
    )
    owner new_resource.user.name
    group new_resource.user.name
    mode "0755"
    backup false
  end
end

action :delete do
  file "#{new_resource.user.home_path}/.profile.d/#{new_resource.filename}" do
    action :delete
  end
end
