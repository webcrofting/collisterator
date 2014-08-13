class ItemsController < ApplicationController
 #before_filter :authenticate_user!, :except => [:show]

  # GET /items/1
  # GET /items/1.json
  def show
    @item = find_item_by_id_or_token(params[:id])
    #logger.debug "item's id is #{@item.id}"
    
    respond_to do |format|
      format.html # show.html.erb
      format.json {render json: @item}
    end
  end

  # POST /items
  # POST /items.json
  def create
		@item = ItemCreator.new(params, current_user).result
	
    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
  @item = find_item_by_id_or_token(params[:id])

	@item.data.merge! params[:item][:data] if params[:item][:data]
	@item.save
	
	logger.debug "Item data is #{@item.data}"
	
     respond_to do |format|
	     format.html {
         if request.xhr?
	         render :text => params[:item].values.first
         else
           redirect_to(@item, :notice => 'Item was successfully updated.')
         end
	    }
      format.json { head :no_content }
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = find_item_by_id_or_token(params[:id])

    @item.children.each do |child|
        child.parent_id = nil
    end

    @item.destroy
		head :ok	
  end
end
