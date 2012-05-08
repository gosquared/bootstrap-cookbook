actions :create, :delete

attribute :username,       :kind_of => String, :name_attribute => true
attribute :filename,       :kind_of => String,  :default => "default"
attribute :params,         :kind_of => Array,   :required => true

def initialize(*args)
  super
  @action = :create
end

def user(arg=nil)
  set_or_return(
    :user,
    (arg or Chef::Resource::BootstrapSystemUser.new(username)),
    :kind_of => [ Object ]
  )
end
