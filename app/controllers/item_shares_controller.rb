class ItemSharesController < ApplicationController
	
	def new
		@item_share = ItemShare.new
		respond_with @item_share
		#is that even necessary???
	end
	
	def create
		@shared_user_email = params[:shared_user_email]
		logger.debug "#{@shared_user_email}"
		respond_to do |format|
			if @item_share.save
				format.html {redirect_to user_path(current_user.id), :notice => "List shared successfully"}
			else
				flash.now[:alert] = "Could not submit new share list form."
			end
		end
	end
	
end
