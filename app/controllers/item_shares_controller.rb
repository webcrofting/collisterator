class ItemSharesController < ApplicationController

	def create
    @item_share = ItemShare.new item_shares_params
    if @item_share.save
      #TODO: fix deprecation warning on #deliver
      #UserMailer.shared_list_notification(@item_share).deliver
      flash[:notice] = "Item successfully shared."
      redirect_to current_user
    else
      flash[:error] = "Error sharing list."
      flash[:share_params] = params[:item_share]
      redirect_to :action => :new
    end
  end

  def item_shares_params
    params.require(:item_share).permit(:item_id, :owner_id, :shared_user_email)
  end
end
