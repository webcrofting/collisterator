class ItemsController < ApplicationController
  
 
 # GET /items
 # GET /items.json 
  def index
    @items = Item.roots

    respond_to do |format|
      format.html # index.html.erb
	  #format.html { render json: @items } # for debugging json
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json {render json: @item}
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(params[:item])

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
	@item = Item.find(params[:id])
	@item.data = params[:value]
	#@item.update_attributes!(params[:item])
	
	logger.debug "Item data is #{@item.data}"
	
	format.html {
		if request.xhr?
			render :text => params[:item].values.first
		else
			redirect_to(@item, :notice => 'Item was successfully updated.')
		end
	}
	
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end
end
