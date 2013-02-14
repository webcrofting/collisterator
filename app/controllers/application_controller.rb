class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def find_item_by_id_or_token(id_or_token)

  
    if (Item.find_by_token(id_or_token).blank?)
      #logger.debug "in application controller if clause, id_or_token is: #{id_or_token}"
      item = Item.find_by_id(id_or_token)
    else
      item = Item.find_by_token(id_or_token)
    end 
    #logger.debug "items id is #{item.id}"
    return item
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
  
end
