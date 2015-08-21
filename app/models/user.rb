class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  #TODO : would be better as an enum!
  # SHOULD ALSO VALIDATE THIS
  ROLES = %w[admin payer player]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [ :google_oauth2]

  before_create :set_default_role
  after_create :send_welcome_email
  has_many :items
  has_many :list_types
  #validates_inclusion_of :role, :in => ROLES


  def player?
    role == "player"
  end

  def payer?
    role == "payer"
  end

  def admin?
    role == "admin"
  end

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
        user = User.create!(username: data["name"],
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
	@item_shares = ItemShare.find_by_shared_user_email(self.email)
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
    if self.role==role_string
      return true
    else
      return false
    end
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
    if ROLES.include?(role_string)
      self.role = role_string
    else
      puts "#{role_string} is not a role."
    end
  end

  private
  def set_default_role
    unless self.role
      self.role = "player"
    end
  end

  def send_welcome_email
    # TODO: FIX THIS!
    #UserMailer.welcome(self).deliver
  end
end
