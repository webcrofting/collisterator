class ItemSharesController < ApplicationController
	
	def new
		@item_share = ItemShare.new
	end
	
	def create
    @item_share = ItemShare.new params[:item_share]
    if @item_share.save
      flash[:notice] = "Item successfully shared."
      redirect_to current_user
    else
      flash[:error] = "Error sharing list."
      flash[:share_params] = params[:item_share]
      redirect_to :action => :new
    end
  end
	
end
