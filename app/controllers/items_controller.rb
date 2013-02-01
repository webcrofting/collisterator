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
    @item = Item.new
    @item.parent_id = params[:item][:parent_id]
	
	  #logger.debug "item's parent_id is #{@item.parent_id}"
	
	  if @item.parent_id
		  @parent = Item.find(@item.parent_id)
		  @parent_list_type = ListType.find(@parent.list_type_id)
		
		  logger.debug "parent item's children_list_type_id: #{@parent_list_type.children_list_type_id}"
		
		  if (@parent_list_type.children_list_type_id.blank?) 
			  @item.list_type_id = @parent.list_type_id
		  else
			  @item.list_type_id = @parent_list_type.children_list_type_id
		  end
	  end
	
	  #logger.debug "item's list_type_id is #{@item.list_type_id}"
	
	  @list_type = ListType.find(@item.list_type_id)	
	  @item.data = JSON.parse @list_type.default_data
	
	  #logger.debug "list_types data is #{@list_type.default_data}"
	
	
	
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
	@item.data.merge! params[:item][:data]
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
    @item = Item.find(params[:id])
	
    @item.children.each do |child|
        child.parent_id = nil
    end

    @item.destroy

	respond_to do |format|
      format.js { render :json => @item, :callback => params[:callback]}
    end
  end
end
