class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid
  # attr_accessible :title, :body
  
  has_and_belongs_to_many :roles
  before_create :set_default_role
  
  def role?(role)
    return !!self.roles.find_by_name(role.to_s)
  end
  
  private
  def set_default_role
    self.role ||= Role.find_by_name('players');
  end
end
