class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid, :roles
  
  has_and_belongs_to_many :roles
  accepts_nested_attributes_for :roles
  before_create :set_default_role
  
  def role?(role)
    return !!self.roles.find_by_name(role.to_s)
  end
  
  def assign_role(role_string)
    @role = Role.find_by_name(role_string)
    unless @role.nil?
      self.roles << @role
    end
  end
  
  private
  def set_default_role
    self.role ||= Role.find_by_name('players');
  end
end
