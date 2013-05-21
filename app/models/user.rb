class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [ :google_oauth2]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid, :role_id, :username
 # attr_accessor :shared_items

  has_many :items
  has_many :list_types
  # not sure it needs the two options below??
  #has_one :role
  #accepts_nested_attributes_for :role
  before_create :set_default_role
  
  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(username: data["name"],
          provider:access_token.provider,
          email: data["email"],
          uid: access_token.uid ,
          password: Devise.friendly_token[0,20],
        )
      end
   end
  end
  def templates
    @list_types = ListType.find_by_user_id(self.id)
  end
  
  def shared_items	
	@item_shares = ItemShares.find_by_shared_user_email(self.email)
	@shared_items = []
	unless @item_shares.blank? 
	  @item_shares.each do |item_share|
		@item = Item.find(item_share.item_id)
		@shared_items << @item
	  end
	end
	return @shared_items
  end

  def role?(role_string)
    @role = Role.find_by_name(role_string)
	!!(self.role_id == @role.id)
  end

  
  def root_items
    @roots = []
    self.items.each do |item|
	    if item.parent_id.blank?
		    @roots << item
	    end
    end
    return @roots
  end
  
  def assign_role(role_string)
    @role = Role.find_by_name(role_string)
    unless @role.nil?
      self.role_id = @role.id
    end
  end
  
  private
  def set_default_role
    self.role ||= Role.find_by_name('players');
  end
end
