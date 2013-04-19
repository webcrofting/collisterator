class ItemShares < ActiveRecord::Base
  attr_accessible :item_id, :owner_id, :shared_user_email
end
