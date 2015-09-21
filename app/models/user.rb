class User < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions

  devise :database_authenticatable,
         :omniauthable,
         :recoverable,
         :registerable,
         :rememberable,
         :trackable,
         :validatable,
         :omniauth_providers => [ :google_oauth2]

  belongs_to_active_hash :role
  has_many :items
  has_many :list_types

  # TODO: phase out google_omniauth support
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
    ListType.where(user_id: self.id)
  end

  def shared_items
    item_shares = ItemShare.find_by_shared_user_email(self.email)
    shared_items = []
    unless item_shares.blank?
      item_shares.each do |item_share|
      item = Item.find(item_share.item_id)
      shared_items << item
      end
    end
    shared_items
  end

  def role?(role_string)
    role.try(:name) == role_string
  end


  def root_items
    roots = []
    self.items.each do |item|
      if item.parent_id.blank?
        roots << item
      end
    end
    roots
  end
end
