actions :create, :disable, :delete

attribute :username,         :kind_of => String,  :name_attribute => true
attribute :password,         :kind_of => String,  :default => ''
attribute :groups,           :kind_of => Array,   :default => []
attribute :allows,           :kind_of => Array,   :default => []
attribute :home_basepath,    :kind_of => String,  :default => '/home'
attribute :home_permission,  :kind_of => String,  :default => "0755"
attribute :shell,            :kind_of => String,  :default => "/bin/bash"
attribute :ssh_keys,         :kind_of => Array,   :default => []
attribute :profile,          :kind_of => Array,   :default => []

def initialize(*args)
  super
  @action = :create
end

def home_path
  if username == "root"
    "/root"
  else
    "#{home_basepath}/#{username}"
  end
end
alias :path :home_path

def profile_path
  "#{home_path}/.profile"
end

def hashed_password
  return @hashed_password if @hashed_password

  if password.empty?
    @hashed_password = ''
  else
    @hashed_password = %x{openssl passwd -1 '#{password}'}.chomp
  end
end

def sftp?
  groups.include?("sftp")
end

def rvm?
  groups.include?("rvm")
end

def bash?
  shell.include?("/bin/bash")
end

def home_owner
  if sftp?
    "root"
  else
    username
  end
end

def home_group(arg=nil)
  if sftp?
    "root"
  else
    set_or_return(
      :home_group,
      (arg or username),
      :kind_of => [ String ]
    )
  end
end

def exists?
  `id #{username} 2>&1`.index('uid')
end
